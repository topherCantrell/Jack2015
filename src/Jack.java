import java.io.IOException;
import java.io.PrintStream;

public class Jack extends Base {

    public Jack(String filename) throws IOException {
        super(filename);        
    }
    
    @Override
    public int doCompile(String command,PrintStream ps) {
        if(command.startsWith("DRAWEYES ")) {
            
            if(ps==null) return 2;
            
            String [] coords = command.substring(9).split(",");
            
            String left = "$"+coords[0].trim()+coords[1].trim();
            String right = "$"+coords[2].trim()+coords[3].trim();
            
            ps.println(" byte $01, "+left+", " + right+" ' "+command);
            return 2;
        }
        
        throw new RuntimeException("UNKNOWN: "+command);
    }

    public static void main(String[] args) throws Exception {
        Jack jack = new Jack("Face.txt");
        
        jack.compile(System.out);

    }

}
