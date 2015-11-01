package propellersequencer;

import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

public abstract class Sequencer {
    
    /*
     
     here:        ; Address label
     SET A=22     ; Define a variable
     
     NOP         -> 00          ; No-op (useful for padding)
     PAUSE  msec -> F0, mm, ll  ; Pause for given milliseconds
     RNDGOSUB cnt, aa, bb, cc, .. -> F1 cc, aa, bb, cc, .. ; Pick one of the routines to run at random
     RETURN      -> F2
     GOTO   addr -> FF, mm, ll  ; Jump to the given address
     
     */
    
    public static String replaceAll(String s, String key, String value) {        
        while(true) {
            int i = s.indexOf(key);
            if(i<0) return s;
            s = s.substring(0,i)+value+s.substring(i+key.length());
        }        
    }
    
    public static String twoDigitHex(int value) {
        String ret = Integer.toString(value,16);
        if(ret.length()==1) {
            ret = "0" + ret;
        }
        return "$"+ret;
    }
    
    public static String outputWord(int value) {
        int a = value>>8;
        int b = value & 0xFF;
        return twoDigitHex(a)+", "+twoDigitHex(b);        
    }
    
    
    
    
    protected List<String> lines = new ArrayList<String>();
    protected int linePos;
    
    protected Map<String,Integer> defines = new HashMap<String,Integer>();
    
    public Sequencer(String filename) throws IOException {
        List<String> ls = Files.readAllLines(Paths.get(filename));
        for(String s : ls) {
            int i = s.indexOf(';');
            if(i>=0) s=s.substring(0,i);
            s = s.trim();
            if(!s.isEmpty()) lines.add(s);
        }
    }    
    
    private String doSubstitutions(String s) {
        for(Entry<String, Integer> ent : defines.entrySet()) {
            s = replaceAll(s, ent.getKey(), ""+ent.getValue());
        }
        return s;
    }
    
    public void compile(PrintStream ps) {
        compilePass(null); // First pass. Just find the label addresses.
        compilePass(ps);   // Second pass. Generate code.        
    }
            
    
    protected List<String> getNextLines(int num) {
        List<String> ret = new ArrayList<String>();        
        for(int x=0;x<num;++x) {
            ret.add(lines.get(linePos++));
        }        
        return ret;
    }
    
    public void compilePass(PrintStream ps) {
        
        int address = 0;
                
        for(linePos = 0; linePos<lines.size();) { 
            
            String s = lines.get(linePos++).toUpperCase();
            
            // Labels
            if(s.endsWith(":")) {
                defines.put(s.substring(0, s.length()-1).trim(), address);
                continue;
            }
            
            // Defines
            if(s.startsWith("SET ")) {
                s = s.substring(4).trim();
                int i = s.indexOf("=");
                defines.put(s.substring(0,i).trim(), Integer.parseInt(s.substring(i+1).trim()));
                continue;
            }
            
            // This is a command that can have substituted values
            s = doSubstitutions(s);
            
            // These are the commands we know
            
            if(s.equals("NOP")) {
                address += 1;
                if(ps==null) continue;
                ps.println(" byte $00 ' "+s);
                continue;
            }
            
            if(s.startsWith("PAUSE ")) {
                address += 3;
                if(ps==null) continue;
                int i = s.indexOf(" ");
                i = Integer.parseInt(s.substring(i+1).trim());
                ps.println(" byte $F0, "+outputWord(i)+" ' "+s);
                continue;
            }
            
            if(s.startsWith("GOTO ")) {
                address += 3;
                if(ps==null) continue;
                int i = s.indexOf(" ");
                i = Integer.parseInt(s.substring(i+1).trim());
                ps.println(" byte $FF, "+outputWord(i)+" ' "+s);
                continue;
            }
            
            if(s.startsWith("RNDGOSUB ")) {
                // RNDGOSUB cnt, aa, bb, cc, .. -> F1 cc, aa, bb, cc, .. 
                
                String [] routs = s.substring(9).split(",");
                
                address += (2+routs.length*2);
                
                if(ps==null) continue;
                
                ps.print(" byte $F1, "+Sequencer.twoDigitHex(routs.length));
                for(String rout : routs) {
                    ps.print(" ,"+Sequencer.outputWord(Integer.parseInt(rout.trim())));
                }
                ps.println(" ' "+s);
                
                continue;
                
            }
            
            if(s.startsWith("RETURN")) {
                address += 1;
                if(ps==null) continue;
                ps.println(" byte $F2 ' "+s);
                continue;
            }
            
            if(s.startsWith("ABORT")) {
                address +=1;
                if(ps==null) continue;
                ps.println(" byte $FE ' "+s);
                continue;
            }
            
            // These are the DSL specific commands
            
            address += doCompile(address,s,ps);
            
        }
        
        if(ps!=null) {
            ps.println(" ' "+address+" bytes");
        }
    }

    /**
     * Compile the given command
     * @param command the single line text of the command
     * @param ps the output stream (or null for the first pass)
     * @return the number of data bytes for the command
     */
    protected abstract int doCompile(int address, String command, PrintStream ps);

}
