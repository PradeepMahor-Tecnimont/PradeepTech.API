using DocumentFormat.OpenXml.Spreadsheet;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Base;
using TCMPLApp.DataAccess.Models;
using TCMPLApp.Domain.Context;
using TCMPLApp.Domain.Models.DeskBooking;

namespace TCMPLApp.DataAccess.Repositories.DeskBooking
{
    public class EmpLocationMappingDataTableListRepository : ViewTcmPLRepository<EmpLocationMappingDataTableList>, IEmpLocationMappingDataTableListRepository
    {
        public EmpLocationMappingDataTableListRepository(ViewTcmPLContext context, ILogger<ViewTcmPLContext> logger) : base(context, logger)
        {
        }

        public async Task<IEnumerable<EmpLocationMappingDataTableList>> EmpLocationMappingDataTableListAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_emp_location_mapping_qry.fn_emp_location_mapping_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }

        public async Task<IEnumerable<EmpLocationMappingDataTableList>> EmpLocationMappingDataTableListForExcelAsync(BaseSpTcmPL baseSpTcmPL, ParameterSpTcmPL parameterSpTcmPL)
        {
            CommandText = "desk_book.pkg_db_emp_location_mapping_qry.fn_emp_location_mapping_xl_list";
            return await GetAllAsync(baseSpTcmPL, parameterSpTcmPL);
        }
    }
}
