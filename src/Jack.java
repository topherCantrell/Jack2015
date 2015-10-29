import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

public class Jack extends Base {

    public Jack(String filename) throws IOException {
        super(filename);        
    }
    
    private List<String> mouthPixelSwap(List<String> data) {
        
        // aaaaaaaa bbbbbbbb cccccccc
        // aaaaaaaa bbbbbbbb cccccccc
        // aaaaaaaa bbbbbbbb cccccccc
        // aaaaaaaa bbbbbbbb cccccccc
        // aaaaaaaa bbbbbbbb cccccccc
        // aaaaaaaa bbbbbbbb cccccccc
        // aaaaaaaa bbbbbbbb cccccccc
        // aaaaaaaa bbbbbbbb cccccccc   
        
        // aaaaaaaa aaaaaaaa aaaaaaaa
        // aaaaaaaa aaaaaaaa aaaaaaaa
        // aaaaaaaa aaaaaaaa bbbbbbbb
        // bbbbbbbb bbbbbbbb bbbbbbbb
        // bbbbbbbb bbbbbbbb bbbbbbbb
        // bbbbbbbb cccccccc cccccccc
        // cccccccc cccccccc cccccccc
        // cccccccc cccccccc cccccccc
        
        List<String> ret = new ArrayList<String>();
        String build = "";
        for(int x=0;x<3;++x) {
            for(int row=0;row<8;++row) {
                String ds = data.get(row).substring(x*8,x*8+8);
                build = build + ds;
                if(build.length()==24) {
                    ret.add(build);
                    build = "";
                }
            }
        }
        
        return ret;
    }
    
    @Override
    public int doCompile(String command,PrintStream ps) {
        if(command.startsWith("DRAWEYES ")) {
            
            // DRAWEYES x,y,  x,y
            
            if(ps==null) return 2;
            
            String [] coords = command.substring(9).split(",");
            
            String left = "$"+coords[0].trim()+coords[1].trim();
            String right = "$"+coords[2].trim()+coords[3].trim();
            
            ps.println(" byte $01, "+left+", " + right+" ' "+command);
            return 2;
        }
        
        if(command.startsWith("BLINK ")) {
            
            if(ps==null) return 3;
            
            // BLINK L,R, x,y,  x,y
            String [] coords = command.substring(6).split(",");
            
            String flags = "$"+coords[0].trim()+coords[1].trim();
            String left = "$"+coords[2].trim()+coords[3].trim();
            String right = "$"+coords[4].trim()+coords[5].trim();
            
            ps.println(" byte $02, "+flags+", "+left+", " + right+" ' "+command);
            return 3;
        }
        
        if(command.startsWith("COLORS")) {
            List<String> colors = new ArrayList<String>();
            while(true) {
                List<String> c = getNextLines(1);
                if(c.get(0).equals("#")) break;
                colors.add(c.get(0));
            }
            
            if(ps==null) return colors.size()*4+1;
            
            ps.println(" byte $03, "+Base.twoDigitHex(colors.size())+" ' "+command);
            for(String c : colors) {
                ps.println(" byte "+c);
            }
            
            return colors.size()*4+1;
        }
        
        if(command.startsWith("DRAWMOUTH ")) {
            
            List<String> raster = getNextLines(8);
            raster = mouthPixelSwap(raster);
            
            if(ps==null) return 64*3;
            
            String colorMap = command.substring(10).trim();
            
            ps.println(" byte $04 ' "+command);
            for(int x=0;x<8;++x) {
                String l = raster.get(x);
                ps.print(" byte ");
                for(int y=0;y<24;++y) {
                    char c = l.charAt(y);
                    int i = colorMap.indexOf(c);
                    ps.print(Base.twoDigitHex(i));
                    if(y==23) {
                        ps.println(" ' "+l);
                    } else {
                        ps.print(", ");
                    }
                }
            }
            
            return 64*3;
        }
        
        if(command.startsWith("DRAWNOSE ")) {
            
            List<String> raster = getNextLines(8);
            
            if(ps==null) return 64;
            
            String colorMap = command.substring(9).trim();
            
            ps.println(" byte $05 ' "+command);
            for(int x=0;x<8;++x) {
                String l = raster.get(x);
                ps.print(" byte ");
                for(int y=0;y<8;++y) {
                    char c = l.charAt(y);
                    int i = colorMap.indexOf(c);
                    ps.print(Base.twoDigitHex(i));
                    if(y==7) {
                        ps.println(" ' "+l);
                    } else {
                        ps.print(", ");
                    }
                }
            }
            
            return 64;
        }
        
        throw new RuntimeException("UNKNOWN: "+command);
    }

    public static void main(String[] args) throws Exception {
        Jack jack = new Jack("Face.txt");
        
        jack.compile(System.out);

    }

}
