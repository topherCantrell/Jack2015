import java.io.IOException;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.List;

import propellersequencer.Sequencer;

public class Jack extends Sequencer {
    
    /*
    
     DRAWEYES x,y, x,y
     
     BLINK L,R, x,y,  x,y
     
     COLORS
     ...
     ...
     #
     
     DRAWNOSE charMap
     ...
     ...
     
     DRAWMOUTH charMap
     ...
     ...    
     
     */

    public Jack(String filename) throws IOException {
        super(filename);        
    }
        
    @Override
    public int doCompile(int address,String command,PrintStream ps) {
        if(command.startsWith("DRAWEYES ")) {
            
            // DRAWEYES x,y,  x,y
            
            if(ps==null) return 3;
            
            String [] coords = command.substring(9).split(",");
            
            String left = "$"+coords[0].trim()+coords[1].trim();
            String right = "$"+coords[2].trim()+coords[3].trim();
            
            ps.println(" byte $01, "+left+", " + right+" ' "+command);
            return 3;
        }
        
        if(command.startsWith("BLINK ")) {
            
            if(ps==null) return 4;
            
            // BLINK L,R, x,y,  x,y
            String [] coords = command.substring(6).split(",");
            
            String flags = "$"+coords[0].trim()+coords[1].trim();
            String left = "$"+coords[2].trim()+coords[3].trim();
            String right = "$"+coords[4].trim()+coords[5].trim();
            
            ps.println(" byte $02, "+flags+", "+left+", " + right+" ' "+command);
            return 4;
        }
        
        if(command.startsWith("COLORS")) {
            
            int padding = 0;
            while((address%4) !=2) {
                ++padding;
                ++address;
                if(ps!=null) {
                    ps.println(" byte $00 ' Padding");
                }
            }
            
            // COLORS
            //  ...
            //  ...
            // #
            
            List<String> colors = new ArrayList<String>();
            while(true) {
                List<String> c = getNextLines(1);
                if(c.get(0).equals("#")) break;
                colors.add(c.get(0));
            }
            
            if(ps==null) return colors.size()*4+2+padding;
            
            ps.println(" byte $03, "+Sequencer.twoDigitHex(colors.size())+" ' "+command);
            for(String c : colors) {
                ps.println(" byte "+c);
            }
            
            return colors.size()*4+2+padding;
        }
        
        if(command.startsWith("DRAWMOUTH ")) {
            
            // DRAWMOUTH charMap
            // ...
            // ...
            
            List<String> raster = getNextLines(8);
                        
            if(ps==null) return 64*3+1;
            
            String colorMap = command.substring(10).trim();
            
            ps.println(" byte $04 ' "+command);
            for(int x=0;x<8;++x) {
                String l = raster.get(x);
                ps.print(" byte ");
                for(int y=0;y<24;++y) {
                    char c = l.charAt(y);
                    int i = colorMap.indexOf(c);
                    ps.print(Sequencer.twoDigitHex(i));
                    if(y==23) {
                        ps.println(" ' "+l);
                    } else {
                        ps.print(", ");
                    }
                }
            }
            
            return 64*3+1;
        }
        
        if(command.startsWith("DRAWNOSE ")) {
            
            // DRAWNOSE charMap
            // ...
            // ...
            
            List<String> raster = getNextLines(8);
            
            if(ps==null) return 64+1;
            
            String colorMap = command.substring(9).trim();
            
            ps.println(" byte $05 ' "+command);
            for(int x=0;x<8;++x) {
                String l = raster.get(x);
                ps.print(" byte ");
                for(int y=0;y<8;++y) {
                    char c = l.charAt(y);
                    int i = colorMap.indexOf(c);
                    ps.print(Sequencer.twoDigitHex(i));
                    if(y==7) {
                        ps.println(" ' "+l);
                    } else {
                        ps.print(", ");
                    }
                }
            }
            
            return 64+1;
        }
        
        throw new RuntimeException("UNKNOWN: "+command);
    }

    public static void main(String[] args) throws Exception {
        Jack jack = new Jack("Face.txt");
        
        jack.compile(System.out);

    }

}
