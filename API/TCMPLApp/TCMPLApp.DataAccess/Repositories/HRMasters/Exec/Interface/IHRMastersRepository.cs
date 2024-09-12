using System.Threading.Tasks;
using TCMPLApp.Domain.Models.HRMasters;

namespace TCMPLApp.DataAccess.Repositories.HRMasters
{
    public interface IHRMastersRepository
    {
        public Task<int?> GetEmloyeeCount();

        public Task<int?> GetCostcodeCount();

        #region >>>>>>>>>>> D E S I G N A T I O N   M A S T E R <<<<<<<<<<<<<< 

        public Task<DesignationMasterAdd> AddDesignation(DesignationMasterAdd designationMasterAdd);

        public Task<DesignationMasterUpdate> UpdateDesignation(DesignationMasterUpdate designationMasterUpdate);

        public Task<DesignationMasterDelete> DeleteDesignation(DesignationMasterDelete designationMasterDelete);

        #endregion

        #region >>>>>>>>>>> B A N K C O D E   M A S T E R <<<<<<<<<<<<<< 

        public Task<BankcodeMasterAdd> AddBankcode(BankcodeMasterAdd bankcodeMasterAdd);

        public Task<BankcodeMasterUpdate> UpdateBankcode(BankcodeMasterUpdate bankcodeMasterUpdate);

        public Task<BankcodeMasterDelete> DeleteBankcode(BankcodeMasterDelete bankcodeMasterDelete);

        #endregion

        #region >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<< 

        public Task<CategoryMasterAdd> AddCategory(CategoryMasterAdd categoryMasterAdd);

        public Task<CategoryMasterUpdate> UpdateCategory(CategoryMasterUpdate categoryMasterUpdate);

        public Task<CategoryMasterDelete> DeleteCategory(CategoryMasterDelete categoryMasterDelete);

        #endregion

        #region >>>>>>>>>>> E M P T Y P E   M A S T E R <<<<<<<<<<<<<< 

        public Task<EmptypeMasterAdd> AddEmptype(EmptypeMasterAdd emptypeMasterAdd);

        public Task<EmptypeMasterUpdate> UpdateEmptype(EmptypeMasterUpdate emptypeMasterUpdate);

        public Task<EmptypeMasterDelete> DeleteEmptype(EmptypeMasterDelete emptypeMasterDelete);

        #endregion

        #region >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<< 

        public Task<GradeMasterAdd> AddGrade(GradeMasterAdd gradeMasterAdd);

        public Task<GradeMasterUpdate> UpdateGrade(GradeMasterUpdate gradeMasterUpdate);

        public Task<GradeMasterDelete> DeleteGrade(GradeMasterDelete gradeMasterDelete);

        #endregion

        #region >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<< 

        public Task<LocationMasterAdd> AddLocation(LocationMasterAdd locationMasterAdd);

        public Task<LocationMasterUpdate> UpdateLocation(LocationMasterUpdate locationMasterUpdate);

        public Task<LocationMasterDelete> DeleteLocation(LocationMasterDelete locationMasterDelete);

        #endregion

        #region >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<< 

        public Task<OfficeMasterAdd> AddOffice(OfficeMasterAdd officeMasterAdd);

        public Task<OfficeMasterUpdate> UpdateOffice(OfficeMasterUpdate officeMasterUpdate);

        public Task<OfficeMasterDelete> DeleteOffice(OfficeMasterDelete officeMasterDelete);

        #endregion

        #region >>>>>>>>>>> S U B C O N T R A C T   M A S T E R <<<<<<<<<<<<<< 

        public Task<SubcontractMasterAdd> AddSubcontract(SubcontractMasterAdd subcontractMasterAdd);

        public Task<SubcontractMasterUpdate> UpdateSubcontract(SubcontractMasterUpdate subcontractMasterUpdate);

        public Task<SubcontractMasterDelete> DeleteSubcontract(SubcontractMasterDelete subcontractMasterDelete);

        #endregion

        #region Place master

        public Task<PlaceMasterAdd> AddPlace(PlaceMasterAdd placeMasterAdd);

        public Task<PlaceMasterUpdate> UpdatePlace(PlaceMasterUpdate placeMasterUpdate);

        public Task<PlaceMasterDelete> DeletePlace(PlaceMasterDelete placeMasterDelete);

        #endregion

        #region Qualification master

        public Task<QualificationMasterAdd> AddQualification(QualificationMasterAdd qualificationMasterAdd);

        public Task<QualificationMasterUpdate> UpdateQualification(QualificationMasterUpdate qualificationMasterUpdate);

        public Task<QualificationMasterDelete> DeleteQualification(QualificationMasterDelete qualificationMasterDelete);

        #endregion

        #region Graduation master

        public Task<GraduationMasterAdd> AddGraduation(GraduationMasterAdd graduationMasterAdd);

        public Task<GraduationMasterUpdate> UpdateGraduation(GraduationMasterUpdate graduationMasterUpdate);

        public Task<GraduationMasterDelete> DeleteGraduation(GraduationMasterDelete graduationMasterDelete);

        #endregion

        #region Job Group master

        public Task<JobGroupMasterAdd> AddJobGroup(JobGroupMasterAdd jobGroupMasterAdd);

        public Task<JobGroupMasterUpdate> UpdateJobGroup(JobGroupMasterUpdate jobGroupMasterUpdate);

        public Task<JobGroupMasterDelete> DeleteJobGroup(JobGroupMasterDelete jobGroupMasterDelete);

        #endregion

        #region Job Discipline master

        public Task<JobDisciplineMasterAdd> AddJobDiscipline(JobDisciplineMasterAdd jobDisciplineMasterAdd);

        public Task<JobDisciplineMasterUpdate> UpdateJobDiscipline(JobDisciplineMasterUpdate jobDisciplineMasterUpdate);

        public Task<JobDisciplineMasterDelete> DeleteJobDiscipline(JobDisciplineMasterDelete jobDisciplineMasterDelete);

        #endregion

        #region Job Title master

        public Task<JobTitleMasterAdd> AddJobTitle(JobTitleMasterAdd jobTitleMasterAdd);

        public Task<JobTitleMasterUpdate> UpdateJobTitle(JobTitleMasterUpdate jobTitleMasterUpdate);

        public Task<JobTitleMasterDelete> DeleteJobTitle(JobTitleMasterDelete jobTitleMasterDelete);

        #endregion
    }
}
