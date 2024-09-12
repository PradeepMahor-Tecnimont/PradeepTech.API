using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;

namespace TCMPLApp.DataAccess.Repositories.DMS
{
    public class AiroliEmpInDmUsermasterDataTableListRepository : ViewTcmPLRepository<AiroliEmpInDmMasterDataTableList>, IAiroliEmpInDmUsermasterDataTableListRepository
    {
        public AiroliEmpInDmUsermasterDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<AiroliEmpInDmMasterDataTableList>> AiroliEmpInDmUsermasterDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dm_management_qry.fn_airoli_emp_in_dm_master_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}