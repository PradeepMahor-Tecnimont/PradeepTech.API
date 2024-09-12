using System.Data;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;


namespace TCMPLApp.DataAccess.Repositories.DMS

{
    public interface IEmployeeAssetStatusDataTableListRepository
    {
        public Task<DataTable> EmployeeAssetsDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}