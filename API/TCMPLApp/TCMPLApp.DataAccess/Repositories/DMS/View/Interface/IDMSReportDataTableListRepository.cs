using System.Data;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public interface IDMSReportDataTableListRepository
    {
        public Task<DataTable> DeskManagementStatusExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}