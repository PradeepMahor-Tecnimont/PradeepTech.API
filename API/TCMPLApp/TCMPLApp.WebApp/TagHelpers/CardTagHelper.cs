using Microsoft.AspNetCore.Razor.TagHelpers;
using System.Text;

namespace TCMPLApp.WebApp.TagHelpers
{

    [HtmlTargetElement("card-tag")]
    public class CardTagHelper : TagHelper
    {

        public string cardTitle { get; set; }
        public string subTitle { get; set; }
        public string url { get; set; }
        public string iconStyle { get; set; }
        public string classDivAppend { get; set; }
        public string classDiv { get; set; }

        public string classCardTitleAppend { get; set; }
        public string classCardTitle { get; set; }

        public override void Process(TagHelperContext context, TagHelperOutput output)
        {
            output.TagName = "card-tag";
            output.TagMode = TagMode.StartTagAndEndTag;


            string cardTemp = $@"<div class=""card card-tpl"">
                <div class=""card-header"">
                    <h5>
                        {this.cardTitle}
                    </h5>
                </div>
                <div class=""card-block card-tile"">
                    <a href=""{url}"">
                        <div class=""row align-items-center justify-content-center stretched-link"">
                            <div class=""col"">
                                <h7 class=""mb-2 f-w-300"">{this.subTitle} </h7>
                            </div>
                            <div class=""col-auto"">
                                <i class=""{iconStyle}""></i>
                            </div>
                        </div>
                    </a>
                </div>
            </div>";

            output.PreContent.SetHtmlContent(cardTemp);
        }

        //Sample Code
        //<div class="col-md-4 col-xl-3">
        //    <card-tag card-title="Card Title"
        //              sub-title="This is sub title"
        //              url="@Url.Action("Index", "VaccinationSelf", new { Area = "SWPVaccine" })"
        //              icon-style="fas fa-envelope f-20 text-white theme-green">
        //    </card-tag>
        //</div>
    }

    [HtmlTargetElement("textBox-tag")]
    public class TextBoxTagHelper : TagHelper
    {

        public string textBoxFor { get; set; }
        public string isRequired { get; set; }
        public string placeholder { get; set; }
        public string isReadonly { get; set; }

        public override void Process(TagHelperContext context, TagHelperOutput output)
        {
            output.TagName = "textBox-tag";
            output.TagMode = TagMode.StartTagAndEndTag;
            string tagReadonly = "";
            string tagRequired = "";
            string tagSpan = "";

            string textBoxTemp = "";

            if (isReadonly == "Yes")
            {
                tagReadonly = "readonly";
            }
            if (isRequired == "Yes")
            {
                tagRequired = "required";
                tagSpan = $@"<span asp-validation-for=""{textBoxFor}"" class=""text-danger""></span>";
            }


            textBoxTemp = $@"<label asp-for=""{textBoxFor}"" class=""control-label""></label>
                                <input asp-for=""{textBoxFor}"" class=""form-control"" placeholder=""{placeholder}""
                                {tagReadonly}  {tagRequired} />
                                {tagSpan} ";


            output.PreContent.SetHtmlContent(textBoxTemp);
        }

        //Sample Code
        //<div class="col-md-4 col-xl-3">
        //    <card-tag card-title="Card Title"
        //              sub-title="This is sub title"
        //              url="@Url.Action("Index", "VaccinationSelf", new { Area = "SWPVaccine" })"
        //              icon-style="fas fa-envelope f-20 text-white theme-green">
        //    </card-tag>
        //</div>
    }
    [HtmlTargetElement("textArea-tag")]
    public class TextAreaTagHelper : TagHelper
    {

        public string textBoxFor { get; set; }
        public string isRequired { get; set; }
        public string placeholder { get; set; }

        public override void Process(TagHelperContext context, TagHelperOutput output)
        {
            output.TagName = "textArea-tag";
            output.TagMode = TagMode.StartTagAndEndTag;

            string cardTemp = "";
            if (isRequired == "required")
            {
                cardTemp = $@"<label asp-for=""{textBoxFor}"" class=""control-label""></label>
                                <textarea asp-for=""{textBoxFor}"" class=""form-control""
                                placeholder=""{placeholder}"" rows=""3""  required ></textarea>";
            }
            else
            {
                cardTemp = $@"<label asp-for=""{textBoxFor}"" class=""control-label""></label>
                                <textarea asp-for=""{textBoxFor}"" class=""form-control""
                                placeholder=""{placeholder}"" rows=""3"" ></textarea>";
            }

            output.PreContent.SetHtmlContent(cardTemp);
        }

        //Sample Code
        //<div class="col-md-4 col-xl-3">
        //    <card-tag card-title="Card Title"
        //              sub-title="This is sub title"
        //              url="@Url.Action("Index", "VaccinationSelf", new { Area = "SWPVaccine" })"
        //              icon-style="fas fa-envelope f-20 text-white theme-green">
        //    </card-tag>
        //</div>
    }


}
