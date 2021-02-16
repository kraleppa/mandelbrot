import java.awt.Graphics;
import java.awt.image.BufferedImage;
import javax.swing.JFrame;
import java.io.*;
 
public class Visualization extends JFrame {
    private BufferedImage I;

    public Visualization() throws Exception{
        super("Mandelbrot Set");
        setBounds(100, 100, 800, 600);
        setResizable(false);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        I = new BufferedImage(getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB);
        File file = new File("results.txt");
        BufferedReader br = new BufferedReader(new FileReader(file)); 
        String st; 
        while ((st = br.readLine()) != null) {
            if (st == null) break;
            String[] splited = st.split("\\s+");
            if (splited.length != 3) break;
            if (splited[0] == "" || splited[1] == "" || splited[2] == "" ) break;
            int x = Integer.parseInt(splited[0]);
            int y = Integer.parseInt(splited[1]);
            int iter = Integer.parseInt(splited[2]);
            System.out.println(x + " " + y);
            I.setRGB(x, y, iter | (iter << 8));
        } 
    }
 
    public void paint(Graphics g) {
        g.drawImage(I, 0, 0, this);
    }
 
    public static void main(String[] args) throws Exception{
        new Visualization().setVisible(true);
    }
}