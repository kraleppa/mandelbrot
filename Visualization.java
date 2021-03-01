import java.awt.Graphics;
import java.awt.image.BufferedImage;
import javax.swing.JFrame;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import java.io.*;
import java.lang.ref.Cleaner.Cleanable;
import java.net.*;
 
public class Visualization extends JFrame {
    private BufferedImage I;
    private static int processNumber;
    private static int width = 800;
    private static int height = 600;
    private static int x_position = 400;
    private static int y_position = 300;
    private static int zoom = 200;
    private static boolean isRunning = false;

    public Visualization() throws Exception{
        super("Mandelbrot Set");
        setBounds(100, 100, width, height);
        setResizable(false);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        I = new BufferedImage(getWidth(), getHeight(), BufferedImage.TYPE_INT_RGB);
        this.addMouseListener(new MouseAdapter() {
            public void mousePressed(MouseEvent me) { 
                if (isRunning){
                    return;
                }

                if (me.getButton() == 1){
                    int x = me.getX();
                    int y = me.getY();
                    System.out.println(me); 
                    x_position = x;
                    y_position = y;
                } else if (me.getButton() == 2){
                    zoom = zoom + 100;
                } else if (me.getButton() == 3){
                    zoom = zoom - 100;
                }

                runTask();
            }
        });
        runTask();

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

    public void runTask(){
        isRunning = true;
        new Thread(() -> {
            Socket clientSocket;
            int i = 0;
            try{
                clientSocket = new Socket("127.0.0.1", 8080);
                PrintWriter out = new PrintWriter(clientSocket.getOutputStream(), true);
                BufferedReader in = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
                out.println("{\"width\":" + width + ", \"height\":" + height +
                    ", \"number_of_processes\":" + processNumber+
                    ", \"x_position\":" + x_position + ",\"y_position\": "+ y_position + 
                    ", \"zoom\": "+ zoom +"}");
                
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    if (i >= (height * width) - 1400){
                        break;
                    }
                    i++;
                    System.out.println(i);
                    setRGB(inputLine);
                }
                clientSocket.close();
                System.out.println("OK");
                isRunning = false;

            } catch (Exception e){
                System.out.println("error :(");
            }
        }).start();
    }
}
