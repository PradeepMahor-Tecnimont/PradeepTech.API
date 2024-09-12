using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.HRMasters;
using TCMPLApp.Domain.Models.RapReporting;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class HRMastersCustomImportRepository : ExecTcmPLRepository<ParameterSpTcmPL, HRMastersCustomImportOutput>, IHRMastersCustomImportRepository
    {

        public HRMastersCustomImportRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {

        }        

        public async Task<HRMastersCustomImportOutput> ImportHRMastersCustomAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "timecurr.hr_pkg_emplmast_main.import_custom_employee_master";            
            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response; 
        }        
    }
}
