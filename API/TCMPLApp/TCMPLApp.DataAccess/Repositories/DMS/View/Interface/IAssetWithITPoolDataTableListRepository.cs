using System.Data;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;


namespace TCMPLApp.DataAccess.Repositories.DMS

{
    public interface IAssetWithITPoolDataTableListRepository
    {
        public Task<DataTable> AssetWithITPoolDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL);
    }
}