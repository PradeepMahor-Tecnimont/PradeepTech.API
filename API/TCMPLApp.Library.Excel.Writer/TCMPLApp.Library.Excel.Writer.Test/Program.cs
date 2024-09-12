// See https://aka.ms/new-console-template for more information
using DocumentFormat.OpenXml.Packaging;
using TCMPLApp.Library.Excel.Writer;
using TCMPLApp.Library.Excel.Writer.Model;



// See https://aka.ms/new-console-template for more information
//Console.WriteLine("Hello, World!");

GenerateExcleWorkBook();

//ChangeTableDefinition();

//XLBookWriterGenerate();

void XLBookWriterGenerate()
{


    var fileName = $"DummyDataxlsx.xlsx";
    var nuFileName = $"FileName2.xlsx";

    string tempFilePath = Path.Combine("C:\\temp", fileName);
    string newFilePath = Path.Combine("C:\\temp", nuFileName);

    var data = getData();

    byte[] templateBytes = System.IO.File.ReadAllBytes(tempFilePath);
    byte[] byteContent;
    using (MemoryStream templateStream = new MemoryStream())
    {
        templateStream.Write(templateBytes, 0, (int)templateBytes.Length);

        using (SpreadsheetDocument spreadsheetDocument = SpreadsheetDocument.Open(templateStream, true))
        {
            XLBookWriter.SetCellValue(spreadsheetDocument, "Data", "A2", "Hello");
            XLBookWriter.SetCellValue(spreadsheetDocument, "Data", "A3", "Bolo");
            XLBookWriter.ReplaceDataInXLTable(spreadsheetDocument, "Data", "DumData", data);
            spreadsheetDocument.Save();
            
        }
        //byte[] buffer = templateStream.GetBuffer();
        long length = templateStream.Length;
        byteContent = templateStream.ToArray();
        using (var stream = File.Create(newFilePath))
        {
            stream.Write(byteContent, 0, byteContent.Length);
        }
    }


}
void GenerateExcleWorkBook()
{

    var fileName = $"FileName.xlsx";
    var nuFileName = $"FileName2.xlsx";
    string tempFilePath = Path.Combine("C:\\temp", fileName);
    string newFilePath = Path.Combine("C:\\temp", nuFileName);

    XLWorkBook xLWorkBook = new XLWorkBook("C:\\temp\\DummyDataxlsx.xlsx");

    var data = getData();



    XLWorkBook.XLSheet xlsheet = new XLWorkBook.XLSheet(xLWorkBook, "Data");
    //xlsheet.ReplaceDataInXLTable("DumData", data);

    //xlsheet.AppendDataInExcelNew("Table4", data);
    xlsheet.AppendDataInExcel("DumData", data);

    //xlsheet.SetCellValue("A2", DateTime.Now);
    //xlsheet.SetCellValue("A3", "Deven");

    xLWorkBook.SaveToFile(newFilePath);


}

IEnumerable<DummyModel> getData()
{
    IEnumerable<DummyModel> data1 =
        new DummyModel[]
        {
                    new DummyModel() { Dummycode = "ASA001", Dummyid=11, Dummydate= new DateTime(2023,1,1).Date },
                    new DummyModel() { Dummycode = "ASA002", Dummyid=12, Dummydate= new DateTime(2023,2,2).Date },
                    new DummyModel() { Dummycode = "ASA003", Dummyid=13, Dummydate= new DateTime(2023,3,3).Date },
                    new DummyModel() { Dummycode = "ASA004", Dummyid=14, Dummydate= new DateTime(2023,4,4).Date },
                    new DummyModel() { Dummycode = "ASA005", Dummyid=15, Dummydate= new DateTime(2023,5,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA006", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
                    new DummyModel() { Dummycode = "ASA020", Dummyid=16, Dummydate= new DateTime(2023,6,5).Date },
        };
    return data1;
}

void ChangeTableDefinition()
{
    XLWorkBook xLWorkBook = new XLWorkBook("C:\\temp\\AttendanceStatus_20230904_1844.xlsx");
    XLWorkBook.XLSheet xlsheet = new XLWorkBook.XLSheet(xLWorkBook, "Sheet1");
    xlsheet.ChangeQueryTableDefinition("QueryAttendanceData");
    var nuFileName = $"AttendanceQueryTable_1.xlsx";
    string newFilePath = Path.Combine("C:\\temp", nuFileName);

    xLWorkBook.SaveToFile(newFilePath);


}