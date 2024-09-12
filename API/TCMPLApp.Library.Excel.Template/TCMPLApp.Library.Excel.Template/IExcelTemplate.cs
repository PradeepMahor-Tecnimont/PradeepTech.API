using TCMPLApp.Library.Excel.Template.Models;

namespace TCMPLApp.Library.Excel.Template
{
    public interface IExcelTemplate
    {
        #region Import SelfService Related Files

        public MemoryStream ValidateImport(Stream stream, IEnumerable<ValidationItem> validationItems);

        #endregion Import SelfService Related Files


        #region ImportLeaveClaim

        public MemoryStream ExportLeaveClaims(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<LeaveClaim> ImportLeaveClaims(Stream stream);

        #endregion ImportLeaveClaim


        #region ImportEMployeeMaster

        public MemoryStream ExportEmployeeMaster(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<Employee> ImportEmployeeMaster(Stream stream);

        #endregion ImportEMployeeMaster


        #region ImportHRMastersCustom

        public MemoryStream ExportHRMastersCustom(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<EmployeeCustom> ImportHRMastersCustom(Stream stream);
               
        #endregion


        #region Job budget

        public MemoryStream ExportJobmasterBudget(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<JobmasterBudget> ImportJobmasterBudget(Stream stream);

        #endregion Job master


        #region Manhours projections current jobs

        public MemoryStream ExportProjectionsCurrentJobs(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<ManhoursProjections> ImportProjectionsCurrentJobs(Stream stream);

        #endregion Manhours projections current jobs


        #region Overtime update

        public MemoryStream ExportOvertimeUpdate(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<OvertimeUpdate> ImportOvertimeUpdate(Stream stream);

        #endregion Overtime update


        #region SwpImport Employee Coming To Office

        public MemoryStream ExportEmpComingToOffice(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<EmpComingToOffice> ImportEmpComingToOffice(Stream stream);

        #endregion SwpImport Employee Coming To Office


        #region ImportDMSConsumables

        public MemoryStream ExportConsumables(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<Consumable> ImportConsumables(Stream stream);

        #endregion ImportDMSConsumables


        #region ImportDMS Inventory Groups

        public MemoryStream ExportDMSInvGroupItems(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<InvGroupItem> ImportDMSInvGroupItems(Stream stream);

        #endregion ImportDMS Inventory Groups


        #region ImportDMSMovements

        public MemoryStream ExportDMSEmpAssetMovement(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<EmpAssetMovement> ImportDMSEmpAssetMovement(Stream stream);

        #endregion ImportDMSMovements


        #region Movemast

        public MemoryStream ExportMovemast(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<Movemast> ImportMovemast(Stream stream);

        #endregion ImportDMSMovements


        #region ImportDMSDeskAreaDeskList

        public MemoryStream ExportDMSDeskAreaDeskList(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<DeskAreaDeskList> ImportDMSDeskAreaDeskList(Stream stream);

        #endregion ImportDMSDeskAreaDeskList


        #region ImportDMSDeskAreaUserList

        public MemoryStream ExportDMSDeskAreaUserList(string version, DictionaryCollection dictionaryCollection, int rowLimit);

        public List<DeskAreaUserList> ImportDMSDeskAreaUserList(Stream stream);

        #endregion ImportDMSDeskAreaUserList

        #region ImportLopForExcessLeave

        public MemoryStream ExportLopForExcessLeave(string version, DictionaryCollection dictionaryCollection, int rowLimit);
        
        public List<LopForExcessLeave> ImportLopForExcessLeave(Stream stream);
        
        #endregion ImportLopForExcessLeave
    }
}