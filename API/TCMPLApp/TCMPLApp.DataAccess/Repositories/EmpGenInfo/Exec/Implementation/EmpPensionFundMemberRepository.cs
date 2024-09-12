using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.Common;

namespace TCMPLApp.DataAccess.Repositories.EmpGenInfo
{
    public class EmpPensionFundMemberRepository : ExecTcmPLRepository<ParameterSpTcmPL, DBProcMessageOutput>, IEmpPensionFundMemberRepository
    {
        public EmpPensionFundMemberRepository(ExecTcmPLContext context, ILogger<ExecTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<DBProcMessageOutput> EmpPensionFundMemberCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_eps_4_all.sp_add_emp_eps_4_all";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> EmpPensionFundMemberEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_eps_4_all.sp_update_emp_eps_4_all";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> EmpPensionFundMemberDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_eps_4_all.sp_delete_emp_eps_4_all";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> HREmpPensionFundMemberCreateAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_eps_4_all.sp_add_4hr_emp_eps_4_all";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> HREmpPensionFundMemberEditAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_eps_4_all.sp_update_4hr_emp_eps_4_all";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }

        public async Task<DBProcMessageOutput> HREmpPensionFundMemberDeleteAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_eps_4_all.sp_delete_4hr_emp_eps_4_all";

            var response = await ExecAsync(baseSpTcmPL, parameterSpTcmPL);

            return response;
        }
    }
}