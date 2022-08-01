public class BaldwinQuoteResponseObj {
    public class Details {
        public String type {get;set;} 
        public String name {get;set;} 
        public String value {get;set;} 
        public String limits {get;set;}
        public List<Details> coverage {get;set;}

        public Details(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'type') {
                            type = parser.getText();
                        } else if (text == 'name') {
                            name = parser.getText();
                        } else if (text == 'value') {
                            value = parser.getText();
                        } else if (text == 'limits') {
                            limits = parser.getText();
                        } else if (text == 'limit') {
                            limits = parser.getText();
                        } else if (text == 'coverage') {
                            coverage = arrayOfDetails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Details consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    public String opportunityId {get;set;}
    public Integer executionId {get;set;}
    public Integer parentExecutionId {get;set;}
    public String status {get;set;} 
    public String carrier {get;set;} 
    public String lob {get;set;} 
    public Integer completion {get;set;} 
    public String message {get;set;} 
    public List<Quotes> quotes {get;set;} 

    public BaldwinQuoteResponseObj(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'opportunityId') {
                        opportunityId = parser.getText();
                    } else if (text == 'executionId') {
                        executionId = Integer.valueOf(parser.getText());
                    } else if (text == 'parentExecutionId') {
                        parentExecutionId = Integer.valueOf(parser.getText());
                    } else if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'carrier') {
                        carrier = parser.getText();
                    } else if (text == 'lob') {
                        lob = parser.getText();
                    } else if (text == 'completion') {
                        completion = parser.getIntegerValue();
                    } else if (text == 'message') {
                        message = parser.getText();
                    } else if (text == 'quotes') {
                        quotes = arrayOfQuotes(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public class Quotes {
        public String id {get;set;} 
        public Boolean package_Z {get;set;} // in json: package
        public String status {get;set;} 
        public String term {get;set;} 
        public Double premium {get;set;} 
        public Double totalPremium {get;set;} 
        public String url {get;set;} 
        public String creditScored {get;set;}
        public List<Details> details {get;set;} 

        public Quotes(JSONParser parser) {
            while (parser.nextToken() != System.JSONToken.END_OBJECT) {
                if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                    String text = parser.getText();
                    if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                        if (text == 'id') {
                            id = parser.getText();
                        } else if (text == 'package') {
                            package_Z = parser.getBooleanValue();
                        } else if (text == 'status') {
                            status = parser.getText();
                        } else if (text == 'term') {
                            term = parser.getText();
                        } else if (text == 'premium') {
                            premium = parser.getDoubleValue();
                        } else if (text == 'totalPremium') {
                            totalPremium = parser.getDoubleValue();
                        } else if (text == 'url') {
                            url = parser.getText();
                        } else if (text == 'creditScored') {
                            creditScored = parser.getText();
                        } else if (text == 'details') {
                            details = arrayOfDetails(parser);
                        } else {
                            System.debug(LoggingLevel.WARN, 'Quotes consuming unrecognized property: '+text);
                            consumeObject(parser);
                        }
                    }
                }
            }
        }
    }
    
    
    public static BaldwinQuoteResponseObj parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new BaldwinQuoteResponseObj(parser);
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                depth++;
            } else if (curr == System.JSONToken.END_OBJECT ||
                curr == System.JSONToken.END_ARRAY) {
                depth--;
            }
        } while (depth > 0 && parser.nextToken() != null);
    }

    private static List<Details> arrayOfDetails(System.JSONParser p) {
        List<Details> res = new List<Details>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Details(p));
        }
        return res;
    }

    private static List<Quotes> arrayOfQuotes(System.JSONParser p) {
        List<Quotes> res = new List<Quotes>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new Quotes(p));
        }
        return res;
    }
}