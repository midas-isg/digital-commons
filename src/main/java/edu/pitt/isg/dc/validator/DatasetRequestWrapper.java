package edu.pitt.isg.dc.validator;

import edu.pitt.isg.mdc.dats2_2.Dataset;
import edu.pitt.isg.mdc.dats2_2.DataStandard;
import edu.pitt.isg.mdc.v1_0.*;
import org.apache.commons.lang.ArrayUtils;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.ListIterator;

public class DatasetRequestWrapper extends HttpServletRequestWrapper {

    public DatasetRequestWrapper(HttpServletRequest request) {
        super(request);
    }

    @Override
    public String[] getParameterValues(String name) {
        Dataset dataset = new Dataset();
        Field[] attributes = dataset.getClass().getDeclaredFields();
        attributes = (Field[]) ArrayUtils.addAll(attributes, new Software().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new DataFormatConverters().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new DataService().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new DataVisualizers().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new DiseaseTransmissionModel().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new DiseaseTransmissionTreeEstimators().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new DiseaseForecasters().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new MetagenomicAnalysis().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new ModelingPlatforms().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new PathogenEvolutionModels().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new PhylogeneticTreeConstructors().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new PopulationDynamicsModel().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new SyntheticEcosystemConstructors().getClass().getDeclaredFields());
        attributes = (Field[]) ArrayUtils.addAll(attributes, new DataStandard().getClass().getDeclaredFields());
        for(Field field : attributes) {
            if ((!name.contains("add-") && name.contains(field.getName())) || name.equals("categoryID")) {
                String[] values = super.getParameterValues(name);
                String[] newValues = values.clone();
                ArrayList<String> valuesList = new ArrayList<String>(Arrays.asList(newValues));
                valuesList.replaceAll(String::trim);
                if(valuesList.size() > 1) {
                    ListIterator<String> iterator = valuesList.listIterator();
                    iterator.next();
                    while(iterator.hasNext()) {
                        String value = iterator.next();
                        if(valuesList.get(0).equals(value) || value.equals("")) {
                            iterator.remove();
                        }
                    }
                }
//
//                newValues[0] = newValues[0].trim();
//
//                for (int i=1; i<newValues.length-1; i++) {
//                    if(newValues[0].equals(newValues[i])) {
//                        ArrayUtils.removeElement(newValues, )
//                    }
//                }
//
//                newValues[0] = newValues[0].replaceAll("(,)*$", "");
//
//                if("".equals(newValues[0])) {
//                    newValues[0] = null;
//                } else {
//                    String[] arrayText = newValues[0].split("(,)");
//                    int arraySize = arrayText.length;
//                    if(arraySize == 2){
//                        if(arrayText[0].equals(arrayText[1])){
//                            newValues[0] = arrayText[0];
//                        }
//                    }
//                }

                return valuesList.toArray(new String[valuesList.size()]);
            }
        }
        return super.getParameterValues(name);
    }
}
