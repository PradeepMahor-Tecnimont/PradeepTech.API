using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.DataAccess.Repositories.DMS;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DMS;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class EmpOfficeLocationDataTableListRepository : ViewTcmPLRepository<EmpOfficeLocationDataTableList>, IEmpOfficeLocationDataTableListRepository
    {
        public EmpOfficeLocationDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<EmpOfficeLocationDataTableList>> EmpOfficeLocationDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.eo_employee_office_qry.fn_employee_office_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
        public async Task<IEnumerable<EmpOfficeLocationDataTableList>> EmpOfficeLocationDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "dms.pkg_dms_newjoin_qry.fn_xl_dm_dm_newjoin";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
