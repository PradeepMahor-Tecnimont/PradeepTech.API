using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;

namespace TCMPLApp.WebApp.CustomPolicyProvider
{
    internal class RoleActionRequirement : IAuthorizationRequirement
    {
        public string RequirementType { get; private set; }
        public string RequirmentId { get; private set; }

        public RoleActionRequirement(string requirementType, string requirmentId) { RequirementType = requirementType; RequirmentId = requirmentId; }
    }
}
