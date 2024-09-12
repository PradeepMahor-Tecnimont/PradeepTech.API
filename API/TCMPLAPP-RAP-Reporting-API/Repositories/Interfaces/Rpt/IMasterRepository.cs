namespace RapReportingApi.Repositories.Interfaces.Rpt
{
    public interface IMasterRepository
    {
        //MASTER
        //Activity wise report for the chosen costcode
        object LISTACT(string CostCode);

        // List of Activity Project
        object ListActProj(string Projno);

        // List of Employees by Assign
        object LISTEMP(string CostCode);

        //List of employee by Parent
        object LISTEMP_Parent(string CostCode);

        object PROJACT(string CostCode);

        object TLP_Codes_Master();
    }
}