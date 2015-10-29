import java.io.IOException;
import java.io.PrintStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

public abstract class Base {
    
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
    
    
    
    
    List<String> lines = new ArrayList<String>();
    int linePos;
    
    Map<String,Integer> defines = new HashMap<String,Integer>();
    
    public Base(String filename) throws IOException {
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
            
            if(s.startsWith("PAUSE ")) {
                address += 2;
                if(ps==null) continue;
                int i = s.indexOf(" ");
                i = Integer.parseInt(s.substring(i+1).trim());
                ps.println(" byte $F0, "+outputWord(i)+" ' "+s);
                continue;
            }
            
            if(s.startsWith("GOTO ")) {
                address += 2;
                if(ps==null) continue;
                int i = s.indexOf(" ");
                i = Integer.parseInt(s.substring(i+1).trim());
                ps.println(" byte $FF, "+outputWord(i)+" ' "+s);
                continue;
            }
            
            // These are the DSL specific commands
            
            address += doCompile(s,ps);
            
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
    protected abstract int doCompile(String command, PrintStream ps);

}
