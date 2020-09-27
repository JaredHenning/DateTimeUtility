public class DateTimeUtility {

    public class Request {
        @InvocableVariable(label='DateTime' required=True)
        public DateTime ogDateTime;
        @InvocableVariable(label='Years')
        public Integer years;        
        @InvocableVariable(label='Months')
        public Integer months;        
        @InvocableVariable(label='Days')
        public Integer days;        
        @InvocableVariable(label='Hours')
        public Integer hours;        
        @InvocableVariable(label='Minutes')
        public Integer minutes;
    }
    
    public class Result {
        @InvocableVariable(label='DateTime')
        public DateTime newDateTime;
    }   

    @InvocableMethod(label='Create New DateTime' 
                     description='Increment DateTime Object in Flow without the need for a formula')    
    public static List<Result> getNewDT(List<Request> requests) {
        
        List<Result> results = New List<Result>();        
        
        for(Request input : requests) {
			try {
                // Split original DateTime object into separate Date and Time Objects, then modify
                //  separately, recombine, and return as a new DateTime object
                
                Date ogDate = getDate(input);                
                Time ogTime = getTime(input);
                
                Date newDate = modifyDate(ogDate, input);
                Time newTime = modifyTime(ogTime, input);
                
                DateTime newDateTime = DateTime.newInstance(newDate, newTime);
                
                Result output = New Result();
                output.newDateTime = newDateTime;
                
                results.add(output);
                
            } catch(Exception e) {
                // Return original DateTime without modifications
                
                Result output = New Result();
                output.newDateTime = input.ogDateTime;
                
                results.add(output);
            } 
        }
        return results;
    }
    
    private static Date getDate(Request input) {
        return Date.newInstance(input.ogDateTime.year(), 
                                input.ogDateTime.month(), 
                                input.ogDateTime.day());
    }
    
    private static Time getTime(Request input) {
        return Time.newInstance(input.ogDateTime.hour(),
                                input.ogDateTime.minute(), 
                                input.ogDateTime.second(), 
                                input.ogDateTime.millisecond());
    }
    
    private static Date modifyDate(Date ogDate, Request input) {
        Integer years = input.years == Null ? 0 : input.years;
        Integer months = input.months == Null ? 0 : input.months;
        Integer days = input.days == Null ? 0 : input.days;
        Integer hours = input.hours == Null ? 0 : input.hours;
        Integer minutes = input.minutes == Null ? 0 : input.minutes;

        // Allow for hour/minute additions to spill into next day
        // Example: adding 15 minutes to 12/31/1999, 11:45PM will result in 1/1/2000, 12:00AM 
        
        Integer extraHours = (minutes + input.ogDateTime.minute()) / 60;
        Integer extraDays = (hours + input.ogDateTime.hour() + extraHours ) / 24;
        
        return ogDate.addYears(years).addMonths(months).addDays(days + extraDays);
    }
    
    private static Time modifyTime(Time ogTime, Request input) {
        Integer hours = input.hours == Null ? 0 : input.hours;
        Integer minutes = input.minutes == Null ? 0 : input.minutes;      
        
        return ogTime.addHours(hours).addMinutes(minutes);
    }
         
}