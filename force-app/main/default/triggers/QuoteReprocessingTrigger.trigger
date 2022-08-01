trigger QuoteReprocessingTrigger on Quote_Response_Reprocess__e (after insert) {
        for(Quote_Response_Reprocess__e record :trigger.new) {
            if(Trigger.isAfter)
                BaldwinAsyncQuoteWebservice.retryDoInsert(record.Response_JSON__c, Integer.valueOf(record.Retry_Count__c));
        }
}