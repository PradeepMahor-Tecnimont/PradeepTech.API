using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.Domain.Models.HRMasters
{
    public static class HRMastersProcedure
    {
        #region >>>>>>>>>>> E M P L O Y E E   M A S T E R <<<<<<<<<<<<<<

        public static string EmployeeMasterMainAdd
        {
            get => "timecurr.hr_pkg_emplmast_main.add_employee";
        }

        public static string EmployeeMasterMainEdit
        {
            get => "timecurr.hr_pkg_emplmast_main.edit_employee_main";
        }

        public static string DeactivateEmployee
        {
            get => "timecurr.hr_pkg_emplmast_main.deactivate_employee";
        }

        public static string ActivateEmployee
        {
            get => "timecurr.hr_pkg_emplmast_main.activate_employee";
        }

        public static string CloneEmployee
        {
            get => "timecurr.hr_pkg_emplmast_main.clone_employee";
        }
        
        public static string EmployeeMasterAddressEdit
        {
            get => "timecurr.hr_pkg_emplmast_tabs.update_address_tab";
        }

        public static string EmployeeMasterApplicationsEdit
        {
            get => "timecurr.hr_pkg_emplmast_tabs.update_applications_tab";
        }

        public static string EmployeeMasterOrganizationEdit
        {
            get => "timecurr.hr_pkg_emplmast_tabs.update_organization_tab";
        }

        public static string EmployeeMasterRolesEdit
        {
            get => "timecurr.hr_pkg_emplmast_tabs.update_roles_tab";
        }

        public static string EmployeeMasterMiscEdit
        {
            get => "timecurr.hr_pkg_emplmast_tabs.update_misc_tab";
        }

        #endregion

        #region >>>>>>>>>>> U T I L I T I E S  <<<<<<<<<<<<<<

        public static string BulkHoDMngrEdit
        {
            get => "timecurr.hr_pkg_emplmast_main.bulk_hod_mngr_change";
        }

        #endregion

        #region Cost center master

        public static string CostCenterMasterMainCreate
        {
            get => "timecurr.hr_pkg_costmast_main.create_cost_center";
        }

        public static string CostCenterMasterMainUpdate
        {
            get => "timecurr.hr_pkg_costmast_main.update_cost_center";
        }

        public static string DeactivateCostCenter
        {
            get => "timecurr.hr_pkg_costmast_main.deactivate_cost_center";
        }

        public static string CostCenterMasterHoDUpdate
        {
            get => "timecurr.hr_pkg_costmast_hod.update_cost_center_dy_hod";
        }

        public static string CostCenterMasterCostControlUpdate
        {
            get => "timecurr.hr_pkg_costmast_costcontrol.update_cost_center_costcontrol";
        }

        public static string CostCenterMasterAFCUpdate
        {
            get => "timecurr.hr_pkg_costmast_afc.update_cost_center_afc";
        }

        #endregion

        #region >>>>>>>>>>> H O L I D A Y   M A S T E R <<<<<<<<<<<<<<

        public static string HolidayMasterAdd
        {
            get => "timecurr.hr_pkg_holiday.add_holiday";
        }

        public static string HolidayMasterUpdate
        {
            get => "timecurr.hr_pkg_holiday.update_holiday";
        }

        public static string DeleteHoliday
        {
            get => "timecurr.hr_pkg_holiday.delete_holiday";
        }

        public static string PopulateWeekendHoliday
        {
            get => "timecurr.hr_pkg_holiday.polupate_weekend_holidays";
        }
        

        #endregion

        #region >>>>>>>>>>> D E S G I N A T I O N   M A S T E R <<<<<<<<<<<<<<

        public static string DesignationMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_designation";
        }

        public static string DesignationMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_designation";
        }

        public static string DesignationMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_designation";
        }

        #endregion 

        #region >>>>>>>>>>> B A N K C D O E   M A S T E R <<<<<<<<<<<<<<

        public static string BankcodeMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_bankcode";
        }

        public static string BankcodeMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_bankcode";
        }

        public static string BankcodeMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_bankcode";
        }

        #endregion 

        #region >>>>>>>>>>> C A T E G O R Y   M A S T E R <<<<<<<<<<<<<<

        public static string CategoryMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_category";
        }

        public static string CategoryMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_category";
        }

        public static string CategoryMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_category";
        }

        #endregion 

        #region >>>>>>>>>>> E M P L O Y E E T Y P E   M A S T E R <<<<<<<<<<<<<<

        public static string EmptypeMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_emptype";
        }

        public static string EmptypeMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_emptype";
        }

        public static string EmptypeMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_emptype";
        }

        #endregion

        #region >>>>>>>>>>> G R A D E   M A S T E R <<<<<<<<<<<<<<

        public static string GradeMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_grade";
        }

        public static string GradeMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_grade";
        }

        public static string GradeMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_grade";
        }

        #endregion

        #region >>>>>>>>>>> L O C A T I O N   M A S T E R <<<<<<<<<<<<<<

        public static string LocationMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_location";
        }

        public static string LocationMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_location";
        }

        public static string LocationMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_location";
        }

        #endregion 

        #region >>>>>>>>>>> O F F I C E   M A S T E R <<<<<<<<<<<<<<

        public static string OfficeMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_office";
        }

        public static string OfficeMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_office";
        }

        public static string OfficeMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_office";
        }

        #endregion

        #region >>>>>>>>>>> S U B C O N T R A C T  M A S T E R <<<<<<<<<<<<<<

        public static string SubcontractMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_subcontract";
        }

        public static string SubcontractMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_subcontract";
        }

        public static string SubcontractMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_subcontract";
        }

        #endregion 

        #region Place master

        public static string PlaceMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_place";
        }

        public static string PlaceMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_place";
        }

        public static string PlaceMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_place";
        }

        #endregion

        #region Qualification master

        public static string QualificationMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_qualification";
        }

        public static string QualificationMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_qualification";
        }

        public static string QualificationMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_qualification";
        }

        #endregion

        #region Graduation master

        public static string GraduationMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_graduation";
        }

        public static string GraduationMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_graduation";
        }

        public static string GraduationMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_graduation";
        }

        #endregion

        #region Job Group master

        public static string JobGroupMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_jobGroup";
        }

        public static string JobGroupMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_jobGroup";
        }

        public static string JobGroupMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_jobGroup";
        }

        #endregion

        #region Job Discipline master

        public static string JobDisciplineMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_job_discipline";
        }

        public static string JobDisciplineMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_job_discipline";
        }

        public static string JobDisciplineMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_job_discipline";
        }

        #endregion

        #region Job Title master

        public static string JobTitleMasterAdd
        {
            get => "timecurr.hr_pkg_hrmasters.add_job_title";
        }

        public static string JobTitleMasterUpdate
        {
            get => "timecurr.hr_pkg_hrmasters.update_job_title";
        }

        public static string JobTitleMasterDelete
        {
            get => "timecurr.hr_pkg_hrmasters.delete_job_title";
        }

        #endregion

        #region HR Master Repots
                
        public static string ParentwiseSubcontractList
        {
            get => "timecurr.hr_pkg_emplmast_report.get_subcontract_emp_parentwise";
        }


        #endregion

    }

}
