using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;

namespace TCMPLApp.DataAccess.Repositories.Common
{
    public class SelectTcmPLPagingRepository : ViewTcmPLRepository<DataFieldPaging>, ISelectTcmPLPagingRepository
    {

        public SelectTcmPLPagingRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public virtual async Task<IEnumerable<DataFieldPaging>> ActiveEmployeeListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "tcmpl_hr.pkg_emp_select_list_qry.fn_all_active_employees";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataFieldPaging>> EmployeeListForHRAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_paging_employee_list_4_hr";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }



        public virtual async Task<IEnumerable<DataFieldPaging>> EmployeeListForMngrHodOnBeHalfAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_paging_emplist_4_mngrhod_onbehalf";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


        public virtual async Task<IEnumerable<DataFieldPaging>> EmployeeListForMngrHodAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_paging_emplist_4_mngrhod";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }


        public virtual async Task<IEnumerable<DataFieldPaging>> EmployeeListForSecretary(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "selfservice.iot_select_list_qry.fn_paging_emplist_4_secretary";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public virtual async Task<IEnumerable<DataFieldPaging>> CabinDeskIdListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_deskbook_select_list_qry.fn_paging_cabin_list_4_cabin_booking";

            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

    }
}