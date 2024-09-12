using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.OData.Query;
using Microsoft.AspNetCore.OData.Query.Validator;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.OData;

using Microsoft.OData.ModelBuilder.Config;
using Microsoft.OData.UriParser;
using RapReportingApi.Models;
using RapReportingApi.Models.Middelware;
using System;
using System.Linq;

namespace RapReportingApi.ODataOptionFilters
{
    public class RAP_ODataQueryAttributeFilter : EnableQueryAttribute
    {
        public RAP_ODataQueryAttributeFilter()
        {
            AllowedQueryOptions = AllowedQueryOptions.Count | AllowedQueryOptions.OrderBy |
                                    AllowedQueryOptions.Filter | AllowedQueryOptions.Skip | AllowedQueryOptions.Select |
                                    AllowedQueryOptions.Top;
            //MaxTop = 50;
            //AllowedFunctions = AllowedFunctions.ToUpper | AllowedFunctions.ToLower | AllowedFunctions.Contains;
            AllowedFunctions = AllowedFunctions.ToUpper | AllowedFunctions.ToLower | AllowedFunctions.Contains | AllowedFunctions.EndsWith;
            MaxExpansionDepth = 1;
            HandleReferenceNavigationPropertyExpandFilter = false;

            //AllowedOrderByProperties = { };
        }

        public override void OnActionExecuting(ActionExecutingContext context)
        {
            base.OnActionExecuting(context);
        }

        public override IQueryable ApplyQuery(IQueryable queryable, ODataQueryOptions queryOptions)
        {
            return base.ApplyQuery(queryable, queryOptions);
        }

        public override void ValidateQuery(HttpRequest request, ODataQueryOptions paramQueryOptions)
        {
            IOptions<AppSettings> appSettings = paramQueryOptions.Request.HttpContext.RequestServices.GetService<IOptions<AppSettings>>();

            string controller = paramQueryOptions.Request.Path.ToString().TrimEnd('/');
            if (controller.Contains(@"/"))
                controller = controller.Substring(controller.LastIndexOf('/') + 1);
            IWebHostEnvironment webHostEnvironment = paramQueryOptions.Request.HttpContext.RequestServices.GetService<IWebHostEnvironment>();

            //Read OData Query Settings json
            string queryAttributeJson = System.IO.File.ReadAllText(webHostEnvironment.ContentRootPath + appSettings.Value.RAPAppSettings.ODataQueryOptionsSettingFile);

            //Bind json to Object
            ControllerODataQueryAttributes listQueryAttributes = System.Text.Json.JsonSerializer.Deserialize<ControllerODataQueryAttributes>(queryAttributeJson);

            //Get Controller specific OData Query settings
            ODataQueryAttributes oControllerQueryAttributes = listQueryAttributes.AppODataQueryAttributes.FirstOrDefault(t => t.Key.ToLower() == controller).Value;

            //Validate OData Order By
            if (!(paramQueryOptions.OrderBy == null || oControllerQueryAttributes == null))
            {
                foreach (var node in paramQueryOptions.OrderBy.OrderByNodes)
                {
                    OrderByPropertyNode prop = (OrderByPropertyNode)node;
                    if (!Array.Exists(oControllerQueryAttributes.ColumnsAllowed4Sort, col => col.ToLower() == prop.Property.Name.ToLower()))
                    {
                        throw new ODataException(
                            String.Format("Order on column {0} not allowed.", prop.Property.Name)
                            );
                    }
                }
            }

            //Validate OData Filter
            //if (paramQueryOptions.Filter != null)
            //{
            //    DefaultQuerySettings _defaultQuerySettings = new DefaultQuerySettings { EnableFilter = true };
            //    paramQueryOptions.Filter.Validator = new MyFilterQueryValidator(_defaultQuerySettings, oControllerQueryAttributes.ColumnsAllowed4Filter);
            //}
            base.ValidateQuery(request, paramQueryOptions);
        }

        //public class MyOrderByValidator : OrderByQueryValidator
        //{
        //    // Disallow the 'desc' parameter for $orderby option.
        //    public override void Validate(OrderByQueryOption orderByOption,
        //                                    ODataValidationSettings validationSettings)
        //    {
        //        if (orderByOption.OrderByNodes.Any(
        //                node => node.Direction == OrderByDirection.Descending))
        //        {
        //            throw new ODataException("The 'desc' option is not supported.");
        //        }
        //        base.Validate(orderByOption, validationSettings);
        //    }
        //}
    }

    //public class MyFilterQueryValidator : FilterQueryValidator
    //{
    //    string[] allowedColumns;

    // public MyFilterQueryValidator(DefaultQuerySettings defaultQuerySettings, string[]
    // paramQueryCols) : base() { allowedColumns = paramQueryCols; }

    // public override void ValidateSingleValuePropertyAccessNode( SingleValuePropertyAccessNode
    // propertyAccessNode, ODataValidationSettings settings) { string propertyName = null; if
    // (propertyAccessNode != null) { propertyName = propertyAccessNode.Property.Name.ToLower(); }

    // if (!Array.Exists(allowedColumns, col => col.ToString().ToLower() == propertyName)) { throw
    // new ODataException( String.Format("Filter on {0} not allowed", propertyName)); }
    // base.ValidateSingleValuePropertyAccessNode(propertyAccessNode, settings); }

    //}
}