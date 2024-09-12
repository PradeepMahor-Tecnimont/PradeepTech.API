﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TCMPLApp.WebApp.Models
{
    public class IncidentCreateViewModel
    {        
        
        [Display(Name = "Office")]
        public string Office { get; set; }

        [Display(Name = "Location")]
        public string Loc { get; set; }

        [Display(Name = "Costcode")]
        public string Costcode { get; set; }

        [Display(Name = "Incident date")]
        public DateTime? Incdate { get; set; }

        [Display(Name = "incident time")]
        public string Inctime { get; set; }

        [Display(Name = "Type")]
        public string Inctype { get; set; }

        [Display(Name = "Nature")]
        public string Nature { get; set; }

        [Display(Name = "Head")]
        public bool BHead { get; set; }

        [Display(Name = "Neck")]
        public bool BNeck { get; set; }

        [Display(Name = "Forearm")]
        public bool BForearm { get; set; }

        [Display(Name = "Legs")]
        public bool BLegs { get; set; }

        [Display(Name = "Face")]
        public bool BFace { get; set; }

        [Display(Name = "Shoulder")]
        public bool BShoulder { get; set; }

        [Display(Name = "Elbow")]
        public bool BElbow { get; set; }

        [Display(Name = "Knee")]
        public bool BKnee { get; set; }

        [Display(Name = "Mouth")]
        public bool BMouth { get; set; }

        [Display(Name = "Chest")]
        public bool BChest { get; set; }

        [Display(Name = "Wrist")]
        public bool BWrist { get; set; }

        [Display(Name = "Ankle")]
        public bool BAnkle { get; set; }

        [Display(Name = "Ear")]
        public bool BEar { get; set; }

        [Display(Name = "Abdomen")]
        public bool BAbdomen { get; set; }

        [Display(Name = "Hip")]
        public bool BHip { get; set; }

        [Display(Name = "Foot")]
        public bool BFoot { get; set; }

        [Display(Name = "Eye")]
        public bool BEye { get; set; }

        [Display(Name = "Back")]
        public bool BBack { get; set; }

        [Display(Name = "Thigh")]
        public bool BThigh { get; set; }

        [Display(Name = "Other")]
        public bool BOther { get; set; }

        [Display(Name = "Empno")]
        public string Empno { get; set; }

        [Display(Name = "Name of injuried person")]
        public string Empname { get; set; }

        [Display(Name = "Designation")]
        public string Desg { get; set; }

        [Display(Name = "Age")]
        public string Age { get; set; }

        [Display(Name = "Gender")]
        public string Sex { get; set; }

        [Display(Name = "Subcontract")]
        public string Subcontract { get; set; }

        [Display(Name = "Subcontract name")]
        public string Subcontractname { get; set; }

        [Display(Name = "Referred medical aid")]
        public string Aid { get; set; }

        [Display(Name = "Brief description of accident / incident")]
        public string Description { get; set; }

        [Display(Name = "Probable causes")]
        public string Causes { get; set; }

        [Display(Name = "Immediate action")]
        public string Action { get; set; }        

    }


}