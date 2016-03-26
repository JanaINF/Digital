package de.neemann.digital.core.memory;

import de.neemann.digital.core.BitsException;
import de.neemann.digital.core.Node;
import de.neemann.digital.core.NodeException;
import de.neemann.digital.core.ObservableValue;
import de.neemann.digital.core.element.AttributeKey;
import de.neemann.digital.core.element.Element;
import de.neemann.digital.core.element.ElementAttributes;
import de.neemann.digital.core.element.ElementTypeDescription;

/**
 * @author hneemann
 */
public class Counter extends Node implements Element {

    public static final ElementTypeDescription DESCRIPTION
            = new ElementTypeDescription(Counter.class, "C", "clr")
            .addAttribute(AttributeKey.Bits)
            .addAttribute(AttributeKey.Label);

    private ObservableValue out;
    private ObservableValue clockIn;
    private ObservableValue clrIn;
    private boolean lastClock;
    private int counter;

    public Counter(ElementAttributes attributes) {
        int bits = attributes.getBits();
        this.out = new ObservableValue("out", bits);
    }

    @Override
    public void readInputs() throws NodeException {
        boolean clock = clockIn.getBool();
        if (clock && !lastClock) {
            counter++;
        }
        lastClock = clock;
        if (clrIn.getBool())
            counter = 0;
    }

    @Override
    public void writeOutputs() throws NodeException {
        out.setValue(counter);
    }

    @Override
    public void setInputs(ObservableValue... inputs) throws BitsException {
        clockIn = inputs[0].addObserver(this).checkBits(1, this);
        clrIn = inputs[1].addObserver(this).checkBits(1, this);
    }

    @Override
    public ObservableValue[] getOutputs() {
        return new ObservableValue[]{out};
    }

}
