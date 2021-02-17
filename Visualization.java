import java.awt.Graphics;
import java.awt.image.BufferedImage;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

import java.io.*;
import java.net.*;
 
public class Visualization extends JFrame {
    private BufferedImage I;
    private static int processNumber;

    public Visualization() throws Exception{
        super("Mandelbrot Set");
        setBounds(100, 100, 800, 600);
        setResizable(false);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        I = new BufferedImage(getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB);

        new Thread(() -> {
            try{
                // File file = new File("results.txt");
                // BufferedReader br = new BufferedReader(new FileReader(file)); 
                // String st; 
                // while ((st = br.readLine()) != null) {
                //     setRGB(st);
                // } 
                // br.close();
                Socket clientSocket = new Socket("127.0.0.1", 8080);
                PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);
                BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
                out.println("{\"width\": 800,\"height\": 600, \"number_of_processes\":" + processNumber+", \"x_position\": 500,\"y_position\": 300, \"zoom\": 220}");
                
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    setRGB(inputLine);
                }

            } catch (Exception e){
                System.out.println("error :(");
            }
        }).start();

    }
 
    public void paint(Graphics g) {
        g.drawImage(I, 0, 0, this);
    }

    public void setRGB(final String st){
        String[] splited = st.split("\\s+");
        if (splited.length != 3) return;
        if (splited[0] == "" || splited[1] == "" || splited[2] == "" ) return;
        int x = Integer.parseInt(splited[0]);
        int y = Integer.parseInt(splited[1]);
        int iter = Integer.parseInt(splited[2]);
        I.setRGB(x, y, iter | (iter << 8));
        this.repaint();
        
    }
 
    public static void main(String[] args) throws Exception{
        Visualization.processNumber = Integer.parseInt(args[0]);
        new Visualization().setVisible(true);
    }
}