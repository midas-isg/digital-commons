package edu.pitt.isg.dc.validator;

public class ValidatorError {

    public ValidatorError(ValidatorErrorType errorType, String path, Class exptectedClass) {
        this.errorType = errorType;
        this.path = path;
        this.expectedClass = exptectedClass;
    }

    protected ValidatorErrorType errorType;
    protected String path;
    protected Class expectedClass;

    public Class getExpectedClass() {
        return expectedClass;
    }

    public void setExpectedClass(Class expectedClass) {
        this.expectedClass = expectedClass;
    }

    public ValidatorErrorType getErrorType() {
        return errorType;
    }

    @Override
    public String toString() {
        return "Error of type " + getErrorType() + " in path " + getPath() + " variable type is: " + getExpectedClass();
    }

    public void setErrorType(ValidatorErrorType errorType) {
        this.errorType = errorType;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }
}
