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
    
    List<String> lines = new ArrayList<String>();
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
    
    String replaceAll(String s, String key, String value) {        
        while(true) {
            int i = s.indexOf(key);
            if(i<0) return s;
            s = s.substring(0,i)+value+s.substring(i+key.length());
        }        
    }
    
    String doSubstitutions(String s) {
        for(Entry<String, Integer> ent : defines.entrySet()) {
            s = replaceAll(s, ent.getKey(), ""+ent.getValue());
        }
        return s;
    }
    
    String outputWord(int value) {
        int a = value>>8;
        int b = value & 0xFF;        
        return "$"+Integer.toString(a,16)+", $"+Integer.toString(b,16);
    }
            
    public void compile(PrintStream ps) {
        // TODO two passes to get all addresses
        int address = 0;
        for(String s : lines) {
            
            s = s.toUpperCase();
            
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
                int i = s.indexOf(" ");
                i = Integer.parseInt(s.substring(i+1).trim());
                ps.println(" byte $F0, "+outputWord(i)+" ' "+s);
                continue;
            }
            
            if(s.startsWith("GOTO ")) {
                int i = s.indexOf(" ");
                i = Integer.parseInt(s.substring(i+1).trim());
                ps.println(" byte $FF, "+outputWord(i)+" ' "+s);
                continue;
            }
            
            // These are the DSL commands
            doCompile(s,ps);
            
        }
    }

    protected abstract void doCompile(String command,PrintStream ps);

}
