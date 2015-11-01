import java.util.Random;

public class RPat {
    
    public static void main(String [] args) {
        
        Random rand = new Random();
        
        for(int x=0;x<8;++x) {
            for(int y=0;y<24;++y) {
                int i = rand.nextInt(10);
                char c = (char)('A'+i);
                System.out.print(c);
            }
            System.out.println();
        }
        
    }

}
