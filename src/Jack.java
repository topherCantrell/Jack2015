import java.io.IOException;
import java.io.PrintStream;
import java.util.List;

import propellersequencer.Sequencer;

public class Jack extends Sequencer {
    
    /*
    
     DRAWEYES x,y, x,y
     
     BLINK L,R, x,y,  x,y
     
     COLORS count
     ...
     ...     
     
     DRAWNOSE charMap
     ...
     ...
     
     DRAWMOUTH charMap
     ...
     ...    
     
     EYEPATTERN charMap
     ... ...
     ... ...
     
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
            if(coords.length==2) {
                String [] nc = new String[4];
                nc[0] = coords[0];
                nc[1] = coords[1];
                nc[2] = coords[0];
                nc[3] = coords[1];
                coords = nc;
            }
            
            String left = "$"+coords[0].trim()+coords[1].trim();
            String right = "$"+coords[2].trim()+coords[3].trim();
            
            ps.println(" byte $01, "+left+", " + right+" ' "+command);
            return 3;
        }
        
        if(command.startsWith("BLINK ")) {
            
            // BLINK L,R, x,y,  x,y
            
            if(ps==null) return 4;
            
            String [] coords = command.substring(6).split(",");
            
            if(coords.length==4) {
                String [] nc = new String[6];
                nc[0] = coords[0];
                nc[1] = coords[1];
                nc[2] = coords[2];
                nc[3] = coords[3];
                nc[4] = coords[2];
                nc[5] = coords[3];
                coords = nc;
            }
            
            String flags = "$"+coords[0].trim()+coords[1].trim();
            String left = "$"+coords[2].trim()+coords[3].trim();
            String right = "$"+coords[4].trim()+coords[5].trim();
            
            ps.println(" byte $02, "+flags+", "+left+", " + right+" ' "+command);
            return 4;
        }
        
        if(command.startsWith("NOSECOLORS ")) {
            
            // COLORS size
            //  ...
            //  ...
            
            int padding = 0;
            while((address%4) !=2) {
                ++padding;
                ++address;
                if(ps!=null) {
                    ps.println(" byte $00 ' Padding");
                }
            }
            
            int size = Integer.parseInt(command.substring(11).trim());
                        
            List<String> colors = this.getNextLines(size);
                        
            if(ps==null) return colors.size()*4+2+padding;
            
            ps.println(" byte $03, "+Sequencer.twoDigitHex(colors.size())+" ' "+command);
            for(String c : colors) {
                ps.println(" byte "+c+", $00");
            }
            
            return colors.size()*4+2+padding;
        }
        
        if(command.startsWith("MOUTHCOLORS ")) {
            
            // COLORS size
            //  ...
            //  ...
            
            int padding = 0;
            while((address%4) !=2) {
                ++padding;
                ++address;
                if(ps!=null) {
                    ps.println(" byte $00 ' Padding");
                }
            }
            
            int size = Integer.parseInt(command.substring(12).trim());
                        
            List<String> colors = this.getNextLines(size);
                        
            if(ps==null) return colors.size()*4+2+padding;
            
            ps.println(" byte $09, "+Sequencer.twoDigitHex(colors.size())+" ' "+command);
            for(String c : colors) {
                ps.println(" byte "+c+", $00");
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
                    //System.out.println((int)l.charAt(y));
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
        
        if(command.startsWith("EYEPATTERN ")) {
            // EYEPATTERN charMap
            // ... ...
            // ... ...
            
            List<String> raster = getNextLines(8);
            
            if(ps==null) return 32+1;
            
            String colorMap = command.substring(11).trim();
            
            int[][] leftEye = new int[2][8];
            int[][] rightEye = new int[2][8];
                        
            ps.println(" byte $06 ' "+command);
            
            for(int x=0;x<8;++x) {
                String l = raster.get(x);
                for(int y=0;y<8;++y) {
                    char c = l.charAt(y);
                    int i = colorMap.indexOf(c);
                    if((i&1)>0) leftEye[0][x] |= (1<<y);
                    if((i&2)>0) leftEye[1][x] |= (1<<y);
                    c = l.charAt(y+8);
                    i = colorMap.indexOf(c);
                    if((i&1)>0) rightEye[0][x] |= (1<<y);
                    if((i&2)>0) rightEye[1][x] |= (1<<y);
                }
            }
            
            ps.print(" byte ");
            for(int x=0;x<8;++x) {
                ps.print(twoDigitHex(leftEye[0][x])+", "+twoDigitHex(leftEye[1][x]));
                if(x!=7) ps.print(", ");
                else ps.println();
            }
            
            ps.print(" byte ");
            for(int x=0;x<8;++x) {
                ps.print(twoDigitHex(rightEye[0][x])+", "+twoDigitHex(rightEye[1][x]));
                if(x!=7) ps.print(", ");
                else ps.println();
            }
                        
            return 32+1;
            
        }
        
        if(command.startsWith("RNDPALETTENOSE ")) {
            if(ps==null) return 2;
            
            ps.println(" byte $07, "+twoDigitHex(Integer.parseInt(command.substring(15).trim()))+" ' "+command);
            return 2;
            
        }
        
        if(command.startsWith("RNDPALETTEMOUTH ")) {
            if(ps==null) return 2;
            
            ps.println(" byte $0A, "+twoDigitHex(Integer.parseInt(command.substring(16).trim()))+" ' "+command);
            return 2;
            
        }
        
        if(command.startsWith("RNDEYES")) {
            if(ps==null) return 1;
            ps.println(" byte $08 ' "+command);
            return 1;
        }
        
        throw new RuntimeException("UNKNOWN: "+command);
    }

    public static void main(String[] args) throws Exception {
        
        Jack jack = new Jack("Face.txt");
        
        jack.compile(System.out);

    }

}
