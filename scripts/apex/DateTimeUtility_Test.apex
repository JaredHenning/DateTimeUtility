@isTest
public class DateTimeUtility_Test {

    @isTest
    public static void getNewDT_Test() {
        List<DateTimeUtility.Request> requests = New List<DateTimeUtility.Request>();
        
        for(Integer i = 5; i > 0; i--) {
            DateTimeUtility.Request tempRequest = New DateTimeUtility.Request();
            DateTime tempDateTime = DateTime.newInstance(1999, 12, 31, 23, 59, 0);
            tempRequest.ogDateTime = tempDateTime;
            
            requests.add(tempRequest);
        }
        
        requests.add(New DateTimeUtility.Request());
        
        requests[0].minutes = 1;
        requests[1].hours = 10;
        requests[2].days = -365;
        requests[3].months = 10;        
        requests[4].years = -100;
        
        List<DateTimeUtility.Result> results = DateTimeUtility.getNewDT(requests);
        DateTime control = DateTime.newInstance(1999, 12, 31, 23, 59, 0);

        System.assertEquals(control.addMinutes(1), results[0].newDateTime, 'Test1 failed');
		System.assertEquals(control.addHours(10), results[1].newDateTime, 'Test2 failed');
        System.assertEquals(control.addDays(-365), results[2].newDateTime, 'Test3 failed');
        System.assertEquals(control.addMonths(10), results[3].newDateTime, 'Test4 failed');
        System.assertEquals(control.addYears(-100), results[4].newDateTime, 'Test5 failed');
        System.assertEquals(Null, results[5].newDateTime, 'Test6 failed');
    }
    
    @isTest
    public static void getNewDT_BulkTest() {
        List<DateTimeUtility.Request> requests = New List<DateTimeUtility.Request>();
        
        for(Integer i = 500; i > 0; i--) {
            DateTimeUtility.Request tempRequest = New DateTimeUtility.Request();
            DateTime tempDateTime = DateTime.newInstance(1999, 12, 31, 23, 59, 0);
            tempRequest.ogDateTime = tempDateTime;
            
            Boolean repeat;
            
            do {                                
                // Random values for time to send with requests
                Integer choice = Integer.valueOf(Math.random()*5);
                Integer choiceValue = Integer.valueOf(Math.random()*100);                

                switch on choice {
                    when 0 {
                        tempRequest.minutes = choiceValue;
                    }    
                    when 1 {
                        tempRequest.hours = choiceValue;
                    }
                    when 2 {
                        tempRequest.days = choiceValue;
                    }
                    when 3 {
                        tempRequest.months = choiceValue;
                    }
                    when else {
                        tempRequest.years = choiceValue;
                    }
                }
                
                // Random decision to repeat loop and add more input to request
                repeat = Integer.valueOf(Math.random()*2) == 0 ? False : True;                
            } while (repeat == True);
                      
            requests.add(tempRequest);
        }
        
        List<DateTimeUtility.Result> results = DateTimeUtility.getNewDT(requests);
        System.assertEquals(500, results.size());
    }
}