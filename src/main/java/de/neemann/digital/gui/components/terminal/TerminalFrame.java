package de.neemann.digital.gui.components.terminal;

import de.neemann.digital.core.element.AttributeKey;
import de.neemann.digital.core.element.ElementAttributes;

import javax.swing.*;
import java.awt.*;


/**
 * @author hneemann
 */
public class TerminalFrame extends JFrame {
    private final JTextArea textArea;
    private final int width;
    private int pos;

    public TerminalFrame(ElementAttributes attr) {
        super(attr.get(AttributeKey.Label));
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        width = attr.get(AttributeKey.TermWidth);
        textArea = new JTextArea(attr.get(AttributeKey.TermHeight), width);
        textArea.setFont(new Font("monospaced", Font.PLAIN, 12));
        getContentPane().add(new JScrollPane(textArea));
        pack();
        setLocationRelativeTo(null);
        setVisible(true);
    }

    public void addChar(char value) {
        if (value == 13 || value == 10) {
            pos = 0;
            textArea.append("\n");
        } else {
            textArea.append("" + value);
            pos++;
            if (pos == width) {
                pos = 0;
                textArea.append("\n");
            }
        }
    }
}
