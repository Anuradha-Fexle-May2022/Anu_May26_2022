public with sharing class ExampleOfDML {
    public ExampleOfDML() {
        try 
        {   
        List<Contact> changedList = new List<Contact>();
        List<Contact> conList = [Select Department , Description from Contact];
            for(Contact con : conList) {
                if (con.Department == 'Finance') {
                    con.Description = 'New description';
                    // Add updated contact sObject to the list.
                    changedList.add(con);
                    update changedList;
                    system.debug(con);
                }
            }
        }
        catch(Exception e)
        {
            system.debug('An unexpected error has occurred: ' + e.getMessage());
        }
    }
}