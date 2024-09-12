using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.BG;

namespace TCMPLApp.DataAccess.Repositories.BG
{
    public class BGGuaranteeTypeMasterDetailRepository : ExecTcmPLRepository<ParameterSpTcmPL, BGGuaranteeTypeMasterDetail>, IBGGuaranteeTypeMasterDetailRepository
    {
        public BGGuaranteeTypeMasterDetailRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<BGGuaranteeTypeMasterDetail> BGGuaranteeTypeMasterDetail(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_afc.pkg_bg_guarantee_type_mast_qry.sp_guarantee_type_mast_details";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}