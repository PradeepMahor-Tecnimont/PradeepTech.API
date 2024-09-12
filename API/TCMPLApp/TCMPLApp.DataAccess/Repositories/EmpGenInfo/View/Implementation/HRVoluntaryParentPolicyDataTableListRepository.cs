using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.EmpGenInfo;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class HRVoluntaryParentPolicyDataTableListRepository : ViewTcmPLRepository<HRVoluntaryParentPolicyDataTableList>, IHRVoluntaryParentPolicyDataTableListRepository
    {
        public HRVoluntaryParentPolicyDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<HRVoluntaryParentPolicyDataTableList>> HRVoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_hr_qry.fn_vpp_hr_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<HRVoluntaryParentPolicyDataTableList>> ExcelHRVoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_hr_qry.fn_vpp_hr_list_excel";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<HRVoluntaryParentPolicyDataTableList>> ExcelNotLockedHRVoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_hr_qry.fn_vpp_hr_list_not_locked_xl";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<HRVoluntaryParentPolicyDataTableList>> ExcelNotFiledHRVoluntaryParentPolicyDataTableList(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.vpp_hr_qry.fn_vpp_hr_list_not_filed_xl";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}