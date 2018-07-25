package edu.pitt.isg.dc.utils;

import edu.pitt.isg.mdc.dats2_2.Person;
import org.springframework.util.AutoPopulatingList;

import java.io.Serializable;

public class ReflectionFactoryElementFactory<E> implements AutoPopulatingList.ElementFactory<E>, Serializable {
    private final Class<? extends E> elementClass;

    public ReflectionFactoryElementFactory(Class<? extends E> elementClass) {
        this.elementClass = elementClass;
    }

    @Override
    public E createElement(int index) throws AutoPopulatingList.ElementInstantiationException {
        try {
            return (E) ReflectionFactory.create(this.elementClass);
        }
        catch (InstantiationException ex) {
            throw new AutoPopulatingList.ElementInstantiationException(
                    "Unable to instantiate element class: " + this.elementClass.getName(), ex);
        }
        catch (IllegalAccessException ex) {
            throw new AutoPopulatingList.ElementInstantiationException(
                    "Could not access element constructor: " + this.elementClass.getName(), ex);
        } catch (Exception e) {
            throw new AutoPopulatingList.ElementInstantiationException(
                    "Other error: " + this.elementClass.getName(), e);
        }
    }

    public static void main(String[] args) {
        ReflectionFactoryElementFactory<Person> factory = new ReflectionFactoryElementFactory<>(Person.class);
        factory.createElement(3);

    }
}
