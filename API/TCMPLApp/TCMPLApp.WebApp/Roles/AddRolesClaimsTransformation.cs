using Microsoft.AspNetCore.Authentication;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using System.Text;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using TCMPLApp.WebApp.Models;

namespace TCMPLApp.WebApp.Roles
{
    public class AddRolesClaimsTransformation : IClaimsTransformation
    {
        //private readonly UserManager<ApplicationUser> _userManager;


        //public async Task<ClaimsPrincipal> TransformAsync1(ClaimsPrincipal principal)
        //{
        //    var identity = principal.Identities.FirstOrDefault(x => x.IsAuthenticated);
        //    if (identity == null) return principal;

        //    var user = await _userManager.GetUserAsync(principal);
        //    if (user == null) return principal;
            
        //    // Todo... Add or replace identity.Claims.

        //    return new ClaimsPrincipal(user);
        //}

        public Task<ClaimsPrincipal> TransformAsync(ClaimsPrincipal principal)
        {
            // Clone current identity
            var clone = principal.Clone();
            var newIdentity =  (ClaimsIdentity)clone.Identity;

            // Support AD and local accounts
            var nameId =  principal.Claims.FirstOrDefault(c => c.Type == ClaimTypes.NameIdentifier ||
                                                              c.Type == ClaimTypes.Name);
            if (nameId == null)
            {
                return Task.FromResult(principal);
            }

            // Get user from database
            //var user = await _userService.GetByUserName(nameId.Value);
            //if (user == null)
            //{
            //    return principal;
            //}

            // Add role claims to cloned identity
            //foreach (var role in user.Roles)
            //{
                var claim = new Claim(newIdentity.RoleClaimType, "TEST");
                newIdentity.AddClaim(claim);
            //}

            return Task.FromResult(clone);
        }
    }
}

