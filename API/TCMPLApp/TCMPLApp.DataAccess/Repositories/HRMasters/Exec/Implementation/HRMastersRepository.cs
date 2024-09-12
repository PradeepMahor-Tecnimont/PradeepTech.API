using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public class HRMastersRepository : Base.ExecRepository, IHRMastersRepository
    {
        public HRMastersRepository(Domain.Context.ExecDBContext execDBContext) : base(execDBContext)
        {

        }

        #region >>>>>>>>>>> C O U N T E R  <<<<<<<<<<<<<<

        public async Task<int?> GetEmloyeeCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.EmployeeMasterListCount)).FirstOrDefault();
        }

        public async Task<int?> GetCostcodeCount()
        {
            return (await QueryAsync<int>(HRMastersQueries.CostcodeMasterListCount)).FirstOrDefault();
        }

        #endregion 

        #region >>>>>>>>>>> D E S G I N A T I O N   M A S T E R <<<<<<<<<<<<<<

        public async Task<DesignationMasterAdd> AddDesignation(DesignationMasterAdd designationMasterAdd)
        {
            return await ExecuteProcAsync(designationMasterAdd);
        }

        public async Task<DesignationMasterUpdate> UpdateDesignation(DesignationMasterUpdate designationMasterUpdate)
        {
            return await ExecuteProcAsync(designationMasterUpdate);
        }

        public async Task<DesignationMasterDelete> DeleteDesignation(DesignationMasterDelete designationMasterDelete)
        {
            return await ExecuteProcAsync(designationMasterDelete);
        }

        #endregion 

        #region >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<< 

        public async Task<BankcodeMasterAdd> AddBankcode(BankcodeMasterAdd bankcodeMasterAdd)
        {
            return await ExecuteProcAsync(bankcodeMasterAdd);
        }

        public async Task<BankcodeMasterUpdate> UpdateBankcode(BankcodeMasterUpdate bankcodeMasterUpdate)
        {
            return await ExecuteProcAsync(bankcodeMasterUpdate);
        }

        public async Task<BankcodeMasterDelete> DeleteBankcode(BankcodeMasterDelete bankcodeMasterDelete)
        {
            return await ExecuteProcAsync(bankcodeMasterDelete);
        }

        #endregion

        #region >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<< 

        public async Task<CategoryMasterAdd> AddCategory(CategoryMasterAdd categoryMasterAdd)
        {
            return await ExecuteProcAsync(categoryMasterAdd);
        }

        public async Task<CategoryMasterUpdate> UpdateCategory(CategoryMasterUpdate categoryMasterUpdate)
        {
            return await ExecuteProcAsync(categoryMasterUpdate);
        }

        public async Task<CategoryMasterDelete> DeleteCategory(CategoryMasterDelete categoryMasterDelete)
        {
            return await ExecuteProcAsync(categoryMasterDelete);
        }

        #endregion

        #region >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<< 

        public async Task<EmptypeMasterAdd> AddEmptype(EmptypeMasterAdd emptypeMasterAdd)
        {
            return await ExecuteProcAsync(emptypeMasterAdd);
        }

        public async Task<EmptypeMasterUpdate> UpdateEmptype(EmptypeMasterUpdate emptypeMasterUpdate)
        {
            return await ExecuteProcAsync(emptypeMasterUpdate);
        }

        public async Task<EmptypeMasterDelete> DeleteEmptype(EmptypeMasterDelete emptypeMasterDelete)
        {
            return await ExecuteProcAsync(emptypeMasterDelete);
        }


        #endregion

        #region >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<< 

        public async Task<GradeMasterAdd> AddGrade(GradeMasterAdd gradeMasterAdd)
        {
            return await ExecuteProcAsync(gradeMasterAdd);
        }

        public async Task<GradeMasterUpdate> UpdateGrade(GradeMasterUpdate gradeMasterUpdate)
        {
            return await ExecuteProcAsync(gradeMasterUpdate);
        }

        public async Task<GradeMasterDelete> DeleteGrade(GradeMasterDelete gradeMasterDelete)
        {
            return await ExecuteProcAsync(gradeMasterDelete);
        }

        #endregion

        #region >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<< 

        public async Task<LocationMasterAdd> AddLocation(LocationMasterAdd locationMasterAdd)
        {
            return await ExecuteProcAsync(locationMasterAdd);
        }

        public async Task<LocationMasterUpdate> UpdateLocation(LocationMasterUpdate locationMasterUpdate)
        {
            return await ExecuteProcAsync(locationMasterUpdate);
        }

        public async Task<LocationMasterDelete> DeleteLocation(LocationMasterDelete locationMasterDelete)
        {
            return await ExecuteProcAsync(locationMasterDelete);
        }

        #endregion

        #region >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<< 

        public async Task<OfficeMasterAdd> AddOffice(OfficeMasterAdd officeMasterAdd)
        {
            return await ExecuteProcAsync(officeMasterAdd);
        }

        public async Task<OfficeMasterUpdate> UpdateOffice(OfficeMasterUpdate officeMasterUpdate)
        {
            return await ExecuteProcAsync(officeMasterUpdate);
        }

        public async Task<OfficeMasterDelete> DeleteOffice(OfficeMasterDelete officeMasterDelete)
        {
            return await ExecuteProcAsync(officeMasterDelete);
        }

        #endregion

        #region >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<< 

        public async Task<SubcontractMasterAdd> AddSubcontract(SubcontractMasterAdd subcontractMasterAdd)
        {
            return await ExecuteProcAsync(subcontractMasterAdd);
        }

        public async Task<SubcontractMasterUpdate> UpdateSubcontract(SubcontractMasterUpdate subcontractMasterUpdate)
        {
            return await ExecuteProcAsync(subcontractMasterUpdate);
        }

        public async Task<SubcontractMasterDelete> DeleteSubcontract(SubcontractMasterDelete subcontractMasterDelete)
        {
            return await ExecuteProcAsync(subcontractMasterDelete);
        }

        #endregion

        #region Place master

        public async Task<PlaceMasterAdd> AddPlace(PlaceMasterAdd placeMasterAdd)
        {
            return await ExecuteProcAsync(placeMasterAdd);
        }

        public async Task<PlaceMasterUpdate> UpdatePlace(PlaceMasterUpdate placeMasterUpdate)
        {
            return await ExecuteProcAsync(placeMasterUpdate);
        }

        public async Task<PlaceMasterDelete> DeletePlace(PlaceMasterDelete placeMasterDelete)
        {
            return await ExecuteProcAsync(placeMasterDelete);
        }

        #endregion

        #region Qualification master

        public async Task<QualificationMasterAdd> AddQualification(QualificationMasterAdd qualificationMasterAdd)
        {
            return await ExecuteProcAsync(qualificationMasterAdd);
        }

        public async Task<QualificationMasterUpdate> UpdateQualification(QualificationMasterUpdate qualificationMasterUpdate)
        {
            return await ExecuteProcAsync(qualificationMasterUpdate);
        }

        public async Task<QualificationMasterDelete> DeleteQualification(QualificationMasterDelete qualificationMasterDelete)
        {
            return await ExecuteProcAsync(qualificationMasterDelete);
        }

        #endregion

        #region Graduation master

        public async Task<GraduationMasterAdd> AddGraduation(GraduationMasterAdd graduationMasterAdd)
        {
            return await ExecuteProcAsync(graduationMasterAdd);
        }

        public async Task<GraduationMasterUpdate> UpdateGraduation(GraduationMasterUpdate graduationMasterUpdate)
        {
            return await ExecuteProcAsync(graduationMasterUpdate);
        }

        public async Task<GraduationMasterDelete> DeleteGraduation(GraduationMasterDelete graduationMasterDelete)
        {
            return await ExecuteProcAsync(graduationMasterDelete);
        }

        #endregion

        #region Job Group master

        public async Task<JobGroupMasterAdd> AddJobGroup(JobGroupMasterAdd jobGroupMasterAdd)
        {
            return await ExecuteProcAsync(jobGroupMasterAdd);
        }

        public async Task<JobGroupMasterUpdate> UpdateJobGroup(JobGroupMasterUpdate jobGroupMasterUpdate)
        {
            return await ExecuteProcAsync(jobGroupMasterUpdate);
        }

        public async Task<JobGroupMasterDelete> DeleteJobGroup(JobGroupMasterDelete jobGroupMasterDelete)
        {
            return await ExecuteProcAsync(jobGroupMasterDelete);
        }

        #endregion

        #region Job Discipline master

        public async Task<JobDisciplineMasterAdd> AddJobDiscipline(JobDisciplineMasterAdd jobDisciplineMasterAdd)
        {
            return await ExecuteProcAsync(jobDisciplineMasterAdd);
        }

        public async Task<JobDisciplineMasterUpdate> UpdateJobDiscipline(JobDisciplineMasterUpdate jobDisciplineMasterUpdate)
        {
            return await ExecuteProcAsync(jobDisciplineMasterUpdate);
        }

        public async Task<JobDisciplineMasterDelete> DeleteJobDiscipline(JobDisciplineMasterDelete jobDisciplineMasterDelete)
        {
            return await ExecuteProcAsync(jobDisciplineMasterDelete);
        }

        #endregion

        #region Job Title master

        public async Task<JobTitleMasterAdd> AddJobTitle(JobTitleMasterAdd jobTitleMasterAdd)
        {
            return await ExecuteProcAsync(jobTitleMasterAdd);
        }

        public async Task<JobTitleMasterUpdate> UpdateJobTitle(JobTitleMasterUpdate jobTitleMasterUpdate)
        {
            return await ExecuteProcAsync(jobTitleMasterUpdate);
        }

        public async Task<JobTitleMasterDelete> DeleteJobTitle(JobTitleMasterDelete jobTitleMasterDelete)
        {
            return await ExecuteProcAsync(jobTitleMasterDelete);
        }

        #endregion
    }
}
