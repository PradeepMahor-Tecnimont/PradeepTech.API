
using Microsoft.AspNetCore.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using TCMPLApp.WebApp.Classes;

namespace TCMPLApp.WebApp.CustomPolicyProvider
{
    // This attribute derives from the [Authorize] attribute, adding 
    // the ability for a user to specify an 'age' paratmer. Since authorization
    // policies are looked up from the policy provider only by string, this
    // authorization attribute creates is policy name based on a constant prefix
    // and the user-supplied age parameter. A custom authorization policy provider
    // (`RoleActionPolicyProvider`) can then produce an authorization policy with 
    // the necessary requirements based on this policy name.
    internal class RoleActionAuthorizeAttribute : AuthorizeAttribute
    {
        const string POLICY_PREFIX = "RoleAction";

        string _requirementId = null;
        string _requirementType = null;
        public RoleActionAuthorizeAttribute(string requirementType, string requirementId)
        {
            _requirementId = requirementId;
            _requirementType = requirementType;

            RequirementType = requirementType; 
            RequirementId = requirementId;
        }
        // Get or set the Age property by manipulating the underlying Policy property
        public string RequirementId
        {
            get
            {


                string requirementId = null;
                if (string.IsNullOrEmpty(Policy))
                    return default(string);
                if (Policy.StartsWith(Helper.PolicyNamePrefixRole))
                    requirementId = Policy.Substring( Helper.PolicyNamePrefixRole.Length);
                else if (Policy.StartsWith(Helper.PolicyNamePrefixAction))
                    requirementId = Policy.Substring( Helper.PolicyNamePrefixAction.Length);

                if (!string.IsNullOrEmpty(requirementId))
                {
                    return requirementId;
                }
                return default(string);
            }
            set
            {
                Policy = $"{_requirementType}{value.ToString()}";
            }
        }

        public string RequirementType
        {
            get
            {
                string requirementType = null;

                if (Policy.StartsWith(Helper.PolicyNamePrefixRole))
                    requirementType = Helper.PolicyNamePrefixRole;
                else if (Policy.StartsWith(Helper.PolicyNamePrefixAction))
                    requirementType = Helper.PolicyNamePrefixAction;


                if (!string.IsNullOrEmpty(requirementType))
                {
                    return requirementType;
                }
                return default(string);
            }
            set
            {
                Policy = $"{value.ToString()}{_requirementId}";
            }
        }
    }
}