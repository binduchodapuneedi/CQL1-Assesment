@isTest
public class UpdatepartbatchTest {
 private static Id existingPartId;
  private static Id newPartId;

    private static void setupData() {
        Product2 existingProduct = new Product2(Name = 'TEST_EXISTING', ProductCode = '123', IsActive = true);
        insert existingProduct;

        SQX_Part__c existingPart = new SQX_Part__c(Name = 'TEST_EXISTING', Part_Number__c = '123');
        insert existingPart;
        existingPartId = existingPart.Id;

        SQX_Part__c newPart = new SQX_Part__c(Name = 'TEST_NEW', Part_Number__c = '200');
        insert newPart;
        newPartId = newPart.Id;
    }

    @isTest
    public static void testBatchWithProductMatchAndCreate() {
        setupData();

        Test.startTest();
        Updatepartbatch batch = new Updatepartbatch();
        Database.executeBatch(batch, 200); 
        Test.stopTest();

        SQX_Part__c updatedExistingPart = [SELECT Id, Product__c FROM SQX_Part__c WHERE Id = :existingPartId];
        System.assertNotEquals(null, updatedExistingPart.Product__c, 'Existing part should be linked to existing product.');

        SQX_Part__c updatedNewPart = [SELECT Id, Name, Part_Number__c, Product__c FROM SQX_Part__c WHERE Id = :newPartId];
        System.assertNotEquals(null, updatedNewPart.Product__c, 'New part should be linked to newly created product.');

        Product2 createdProduct = [SELECT Id, Name, ProductCode FROM Product2 WHERE Id = :updatedNewPart.Product__c];
        System.assertEquals('TEST_NEW', createdProduct.Name);
        System.assertEquals('200', createdProduct.ProductCode);
    }
}