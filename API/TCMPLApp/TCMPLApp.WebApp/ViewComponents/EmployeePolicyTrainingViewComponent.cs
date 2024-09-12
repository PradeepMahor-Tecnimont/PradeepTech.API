using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.DataAccess.Repositories.SWPVaccine;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.ViewComponents
{
    [ViewComponent(Name = "EmployeePolicyTraining")]
    public class EmployeePolicyTrainingViewComponent : ViewComponent
    {

        private IEmployeePolicyRepository _employeePolicyRepository;

        public EmployeePolicyTrainingViewComponent(IEmployeePolicyRepository employeePolicyRepository)
        {
            _employeePolicyRepository = employeePolicyRepository;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {

            var training = await _employeePolicyRepository.EmpTrainingDetails(User.Identity.Name);
            //if (training == null)
            //{
            //    training.Onedrive365 = false;
            //    training.Planner = false;
            //    training.Security = false;
            //    training.Sharepoint16 = false;
            //    training.Teams = false;
            //}
            EmployeePolicyTrainingViewModel employeePolicyTraining = new EmployeePolicyTrainingViewModel()
            {
                Onedrive365 = training.Onedrive365,
                Planner = training.Planner,
                Security = training.Security,
                Sharepoint16 = training.Sharepoint16,
                Teams = training.Teams
            };
            employeePolicyTraining.IsTrainingComplete = ((bool)training.Onedrive365
                                                && (bool)training.Planner
                                                && (bool)training.Security
                                                && (bool)training.Sharepoint16
                                                && (bool)training.Teams);

            employeePolicyTraining.Message = employeePolicyTraining.IsTrainingComplete ? "Training pre-requisite test successful." : "After completing your mandatory courses, please write to S.Soni3@tecnimont.in / D.Maurya@tecnimont.in. The status of your mandatory courses will be validated. If found completed, then it will be updated here.  Accordingly, you will be informed about it.";

            return View(employeePolicyTraining);

        }
    }
}
