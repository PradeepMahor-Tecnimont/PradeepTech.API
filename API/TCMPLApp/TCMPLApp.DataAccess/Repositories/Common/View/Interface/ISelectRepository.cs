using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Models;

namespace TCMPLApp.DataAccess.Repositories.Common
{ 
    public interface ISelectRepository
    {
        Task<IEnumerable<DataField>> EmployeeSelectListCacheAsync();

        Task<IEnumerable<DataField>> CostcenterSelectListCacheAsync();

        Task<IEnumerable<DataField>> CostcenterWithEmployeeSelectListCacheAsync();

        Task<IEnumerable<DataField>> CostcenterIdSelectListCacheAsync();

        Task<IEnumerable<DataField>> DesignationSelectListCacheAsync();

        Task<IEnumerable<DataField>> GradeSelectListCacheAsync();

        Task<IEnumerable<DataField>> OfficeSelectListCacheAsync();

        Task<IEnumerable<DataField>> CostGroupSelectListCacheAsync();

        Task<IEnumerable<DataField>> TM01GRPSelectListCacheAsync();

        Task<IEnumerable<DataField>> TMAGRPSelectListCacheAsync();

        Task<IEnumerable<DataField>> CostTypeSelectListCacheAsync();

        Task<IEnumerable<DataField>> CompanyReportSelectListCacheAsync();

        Task<IEnumerable<DataField>> TCMCostCenterSelectListCacheAsync();

        Task<IEnumerable<DataField>> TCMActPhSelectListCacheAsync();

        Task<IEnumerable<DataField>> TCMPasPhSelectListCacheAsync();

        Task<IEnumerable<DataField>> EmptypeSelectListCacheAsync();

        Task<IEnumerable<DataField>> CategorySelectListCacheAsync();

        Task<IEnumerable<DataField>> GenderSelectListCacheAsync();

        Task<IEnumerable<DataField>> CompanySelectListCacheAsync();

        Task<IEnumerable<DataField>> JobPhasesSelectListCacheAsync(string cmid);

        Task<IEnumerable<DataField>> LocationSelectListCacheAsync();

        Task<IEnumerable<DataField>> SubContractSelectListCacheAsync();

        Task<IEnumerable<DataField>> BankcodeSelectListCacheAsync();

        Task<IEnumerable<DataField>> LeaveTypeListCacheAsync();

        Task<IEnumerable<DataField>> ApproversListCacheAsync();

        Task<IEnumerable<DataField>> LeavingReasonSelectListCacheAsync();

        Task<IEnumerable<DataField>> PlaceSelectListCacheAsync();

        Task<IEnumerable<DataField>> GraduationSelectListCacheAsync();

        Task<IEnumerable<DataField>> QualificationSelectListCacheAsync();

        Task<IEnumerable<DataField>> JobGroupSelectListCacheAsync();

        Task<IEnumerable<DataField>> JobGroupJobDisciplineSelectListCacheAsync();

        Task<IEnumerable<DataField>> JobGroupJobDisciplineJobTitleSelectListCacheAsync();

        Task<IEnumerable<DataField>> CostcenterEmployeeSelectListCacheAsync(string hod);

        Task<IEnumerable<DataField>> SecretaryEmployeeSelectListCacheAsync();     

        Task<IEnumerable<DataField>> CostGroupCostcenterIdSelectListCacheAsync();     

        Task<IEnumerable<DataField>> ParentCostcenterCostcenterIdSelectListCacheAsync();

        Task<IEnumerable<DataField>> HRJobgroupSelectListCacheAsync();

        Task<IEnumerable<DataField>> HRJobdisciplineSelectListCacheAsync();

        Task<IEnumerable<DataField>> HRJobtitleSelectListCacheAsync();


    }
}
