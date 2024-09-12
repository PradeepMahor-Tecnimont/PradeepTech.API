using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace TCMPLApp.Domain.Models.SWPVaccine
{
    class SwpVuEmpResponseConfiguration
    {
        class SsEmplmastConfiguration : IEntityTypeConfiguration<SwpVuEmpResponse>
        {
            public void Configure(EntityTypeBuilder<SwpVuEmpResponse> entity)
            {

                    entity.ToView("SWP_VU_EMP_RESPONSE");

                    entity.Property(e => e.Abbr).IsUnicode(false);

                    entity.Property(e => e.Empno)
                        .IsUnicode(false)
                        .IsFixedLength(true);

                    entity.Property(e => e.Emptype)
                        .IsUnicode(false)
                        .IsFixedLength(true);

                    entity.Property(e => e.Grade).IsUnicode(false);

                    entity.Property(e => e.HodApprl).IsUnicode(false);

                    entity.Property(e => e.HodApproveVisible).IsUnicode(false);

                    entity.Property(e => e.HodRejectVisible).IsUnicode(false);

                    entity.Property(e => e.HrApprl).IsUnicode(false);

                    entity.Property(e => e.HrApproveVisible).IsUnicode(false);

                    entity.Property(e => e.HrRejectVisible).IsUnicode(false);

                    entity.Property(e => e.IsAccepted).IsUnicode(false);

                    entity.Property(e => e.IsHodApproved).IsUnicode(false);

                    entity.Property(e => e.IsHrApproved).IsUnicode(false);

                    entity.Property(e => e.IsPolicyAccepted).IsUnicode(false);

                    entity.Property(e => e.Name).IsUnicode(false);

                    entity.Property(e => e.Parent)
                        .IsUnicode(false)
                        .IsFixedLength(true);

                    entity.Property(e => e.ParentName).IsUnicode(false);


            }
        }
    }
}