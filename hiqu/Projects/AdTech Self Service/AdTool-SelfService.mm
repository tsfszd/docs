<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1753764919047" ID="ID_528443167" MODIFIED="1753765901773" TEXT="Authentication">
<icon BUILTIN="help"/>
<node CREATED="1753764919047" ID="ID_629354446" MODIFIED="1753765899917" POSITION="right" TEXT="IPC Portal">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      Create IPC Configuration Portal
    </p>
  </body>
</html>
</richcontent>
<node CREATED="1753767709958" ID="ID_189182858" MODIFIED="1753767734109" TEXT="PortalAuthentication"/>
<node CREATED="1753765202324" ID="ID_1753907520" MODIFIED="1753765843123" TEXT="Consumer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="text-indent: -.25in">
      <b><font size="12.0pt">1.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font></b><font size="10.0pt">every client is assigned a consumer id in IPC. This consumer ID is unique for individual Nexelus client. Multiple companies under same Nexelus instance shares the same consumer ID.<br style="line-height: 107%" />Following is the table for consumer. 1<sup>st</sup>&#160; step of IPC integration is to add an entry in Consumer table to assign consumer id to Nexelus client.<br style="line-height: 107%" />&#160;Please remember this is only 1 time setup for one company. If consumer ID is already assigned to Nexelus Client, we should reuse the consumer ID already assigned instead of creating new consumer ID.<br style="line-height: 107%" /><br style="line-height: 107%" /></font><b><font size="12.0pt"><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in; text-indent: -.25in">
      <font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Table Name <b>PDM_CONSUMER</b><br style="line-height: 107%" /><br style="line-height: 107%" />Following is the structure of this table only with required columns.<o p="#DEFAULT" style="line-height: 107%"></o></font>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in">
      <font size="10.0pt"><br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <o p="#DEFAULT" style="line-height: 107%">
      </o>
      </font>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.0in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Column Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Column Type<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Description<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Consumer_id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Int<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Unique id for consumer, always use max(consumer)_id +1 to assign consumer id to new customer<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Nvarchar(256)<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Name of consumer (company name)<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Type<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Tinyint <o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Type of consumer indicates if it is internal client or external, currently we have only internal consumer whose value is 3.<br />use 3 for Nexelus clients.<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Create_date<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Datetime<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Create_id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Nvarchar(100)<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font>
          </p>
        </td>
      </tr>
    </table>
  </body>
</html>
</richcontent>
<node CREATED="1753765283960" ID="ID_534051665" MODIFIED="1753867299585" TEXT="Account">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: .75in">
      <font size="10.0pt">Every IPC consumer is assigned an account id in IPC. Once account id is assigned to a consumer, this account ID will be used for further integration setup.<o p="#DEFAULT" style="line-height: 107%"></o></font>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: .75in">
      <font size="10.0pt">This account ID setup is one time setup for an individual Nexelus Client. Once Account ID is assigned to a client.<o p="#DEFAULT" style="line-height: 107%"></o></font>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: .75in">
      <font size="10.0pt">The following is the table for consumers.<br style="line-height: 107%" /><br style="line-height: 107%" />Please remember this is only 1 time setup for one company. If the account ID is already assigned to Nexelus Client, we should reuse the account ID already assigned instead of creating new.<o p="#DEFAULT" style="line-height: 107%"></o></font>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in">
      <font size="10.0pt"><o p="#DEFAULT" style="line-height: 107%">
      &#160;</o></font>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in; text-indent: -.25in">
      <font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">PDM_CONSUMER_ACCOUNT<br style="line-height: 107%" /><br style="line-height: 107%" />Following is the structure of this table only with required columns.<br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.0in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Column Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Type<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Description<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="9.5pt" face="Consolas" color="black">account_id</font><font size="10.0pt"><o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Varchar(128)<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Account ID for new client<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Consumer_id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Int<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Foreign key<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Eff_date<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Datetime<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Current date<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Exp_date<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Datetime<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Future date when account will expire.<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
    </table>
  </body>
</html>
</richcontent>
<node CREATED="1753765351836" ID="ID_1847244165" MODIFIED="1753766802239" TEXT="Ad Tool Account">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="text-indent: -.25in">
      <b><font size="3">1.</font><font face="Times New Roman" size="3">&#160;&#160;&#160;&#160;&#160;&#160; </font></b><font size="3">Ad tool setup is required for each ad tool integration. This step requires adding an adtool account and assigning a access_tag to the adtool account.<br size="3" style="line-height: 107%" />Once the client is ready for ad tool integration, the system should create ad tool account in IPC for integration. This setup is required for individual ad-tool for each client.<b><br size="3" style="line-height: 107%" /></b>in this process, system will add entries in following 2 tables.<b><o p="#DEFAULT" size="3" style="line-height: 107%"></o></b>&#160;</font>
    </p>
    <p class="MsoListParagraphCxSpMiddle">
      <b><font size="3"><o p="#DEFAULT" size="3" style="line-height: 107%">
      &#160;</o></font></b>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in; text-indent: -.25in">
      <font size="3">a.</font><font face="Times New Roman" size="3">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="3">PDM_ACCOUNT_USER<br size="3" style="line-height: 107%" /><br size="3" style="line-height: 107%" />Following is the structure of this table only with required columns.<br size="3" style="line-height: 107%" /><br size="3" style="line-height: 107%" /><o p="#DEFAULT" size="3" style="line-height: 107%"></o></font>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.0in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Column Name<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Type<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Description<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font color="black" face="Consolas" size="3">account_id</font><font size="3"><o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Varchar(128)<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Foreign key<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">user_id&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <o p="#DEFAULT" size="3"></o>&#160; </font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">nVarchar<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Unique id<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">user_name<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">nVarchar<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Current date<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Password<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">nVarchar<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Future date when account will expire.<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">is_active<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Tinyint<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3"><o p="#DEFAULT" size="3">
            &#160;</o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">dev_token<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Varchar(256)<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">333 for now for all entries.<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.0in">
      <font size="3"><br size="3" style="line-height: 107%" />
      <br size="3" style="line-height: 107%" />
      <o p="#DEFAULT" size="3" style="line-height: 107%">
      </o>
      </font>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in; text-indent: -.25in">
      <b><font size="3">b.</font><font face="Times New Roman" size="3">&#160;&#160;&#160;&#160;&#160; </font><font size="3">AdTool IDs<o p="#DEFAULT" size="3" style="line-height: 107%"></o></font></b>
    </p>
    <p class="MsoListParagraphCxSpMiddle">
      <font size="3">(<u>pdim_ad_tool</u>)<br size="3" style="line-height: 107%" /><br size="3" style="line-height: 107%" /><o p="#DEFAULT" size="3" style="line-height: 107%"></o></font>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.0in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="264" valign="bottom" style="width: 197.75pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font color="black" face="Aptos Narrow,sans-serif" size="3">ad_tool_id</font></b><font size="3"><o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="264" valign="bottom" style="width: 197.75pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font color="black" face="Aptos Narrow,sans-serif" size="3">AdTool name</font></b><font size="3"><o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">1<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">AdWords<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">2<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">AdCenter<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">6<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">GCM<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">13<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Sizmek<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">14<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">TradeDesk<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">15<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Facebook Ad<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">16<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">MS Ads<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">17<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Yahoo Gemini<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">19<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Google Ads<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">21<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Display &amp; Video 360<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">24<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Twitter<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">25<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">LinkedIn<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="264" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3"><o p="#DEFAULT" size="3">
            &#160;</o>&#160;</font>
          </p>
        </td>
        <td width="264" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3"><o p="#DEFAULT" size="3">
            &#160;</o>&#160;</font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoNormal" style="margin-left: .75in">
      <font size="3"><br size="3" style="line-height: 107%" />
      </font>
    </p>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.0in; text-indent: -.25in">
      <font size="3">c.</font><font face="Times New Roman" size="3">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="3">PDM_ACCOUNT_USER_AD_TOOL<br size="3" style="line-height: 107%" /><br size="3" style="line-height: 107%" />Following are required columns for this table<br size="3" style="line-height: 107%" /><br size="3" style="line-height: 107%" /><o p="#DEFAULT" size="3" style="line-height: 107%"></o></font>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.0in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Column Name<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Type<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Description<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font color="black" face="Consolas" size="3">account_id</font><font size="3"><o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Varchar(128)<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Foreign key<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">ad_tool_id&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <o p="#DEFAULT" size="3"></o>&#160; </font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">int<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Id of adtool, this is predefined id for each adtool. Please ceck adtool id lists for this Entery<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">seq_id<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">int<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Incremental Seq id assigned to this record, for each tool , it starts with 1 <o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">user_id<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Varchar<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Foreign key from pdm_account_user table.<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.0in">
      <font size="3"><br size="3" style="line-height: 107%" />
      <br size="3" style="line-height: 107%" />
      <o p="#DEFAULT" size="3" style="line-height: 107%">
      </o>
      </font>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in; text-indent: -.25in">
      <font size="3">d.</font><font face="Times New Roman" size="3">&#160;&#160;&#160;&#160;&#160;&#160; </font><b><font size="3">pdm_account_ad_tool<br size="3" style="line-height: 107%" /></font></b><font size="3"><br size="3" style="line-height: 107%" />Followings are required columns.<br size="3" style="line-height: 107%" /><br size="3" style="line-height: 107%" /><o p="#DEFAULT" size="3" style="line-height: 107%"></o></font>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.0in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Column Name<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Type<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="3">Description<o p="#DEFAULT" size="3"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font color="black" face="Consolas" size="3">account_id</font><font size="3"><o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Varchar(128)<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Foreign key<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">ad_tool_id&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <o p="#DEFAULT" size="3"></o>&#160; </font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Int<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Id of adtool, this is predefined id for each adtool. Please see section &#8220;c&#8221; above for ids.<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">seq_id<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Int<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Incremental Seq id assigned to this record, for each tool , it starts with 1 <o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">access_tag<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">narchar(256)<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Foreign key from pdm_account_user table.<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">ipc_name<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Nvarchar(256)<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3"><o p="#DEFAULT" size="3">
            &#160;</o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Eff_date<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Datetime<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3"><o p="#DEFAULT" size="3">
            &#160;</o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Exp_date<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3">Datetime<o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="3"><o p="#DEFAULT" size="3">
            &#160;</o>&#160;</font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraph" style="margin-left: 1.0in">
      <font size="3"><o p="#DEFAULT" size="3" style="line-height: 107%">
      &#160;</o>&#160;</font>
    </p>
    <p class="MsoNormal" style="margin-left: .75in">
      <font size="3"><br size="3" style="line-height: 107%" />
      <o p="#DEFAULT" size="3" style="line-height: 107%">
      </o>
      </font>
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753765801446" FOLDED="true" ID="ID_1310905506" MODIFIED="1753857195935" TEXT="Configure Ad Tool Account">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst">
      once IPC account is created for Adtool, net step requires providing configuration data required for integration. This data varies from adtool to adtool. Following table will be populated for configurational data.<br style="line-height: 107%" /><br style="line-height: 107%" /><b><o p="#DEFAULT" style="line-height: 107%"></o></b>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in; text-indent: -.25in">
      a.<font face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font>PDM_ACCOUNT_AD_TOOL_API_ACCESS<font color="black" face="Consolas"><br style="line-height: 107%" /></font>Followings are required columns.<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.0in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b>Column Name<o p="#DEFAULT"></o></b>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b>Type<o p="#DEFAULT"></o></b>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b>Description<o p="#DEFAULT"></o></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font color="black" face="Consolas">account_id</font><o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Varchar(128)<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Foreign key<o p="#DEFAULT"></o>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            ad_tool_id&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; <o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Int<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Id of adtool, this is predefined id for each adtool. Please ceck adtool id lists for this Entery<o p="#DEFAULT"></o>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            seq_id<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Int<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Incremental Seq id assigned to this record, for each tool , it starts with 1 <o p="#DEFAULT"></o>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Api_access_property_id<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Int<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Property_id.id<o p="#DEFAULT"></o>
          </p>
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <o p="#DEFAULT">
            &#160;</o>
          </p>
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Every Adtool has predefined set of properties which needs to be added for each tool.<br />Please review AdTool required information section for api_acce_properties<o p="#DEFAULT"></o>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            api_access_property_id<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Nvarhar(1600)<o p="#DEFAULT"></o>
          </p>
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <o p="#DEFAULT">
            &#160;</o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Property value<o p="#DEFAULT"></o>
          </p>
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <o p="#DEFAULT">
            &#160;</o>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Create_id<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Varchar(100)<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <o p="#DEFAULT">
            &#160;</o>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Create_date<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Datetime<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <o p="#DEFAULT">
            &#160;</o>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Modify_id<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Varchar(100)<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <o p="#DEFAULT">
            &#160;</o>
          </p>
        </td>
      </tr>
      <tr>
        <td width="177" valign="top" style="width: 132.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Modify_date<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="176" valign="top" style="width: 132.05pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            Datetime<o p="#DEFAULT"></o>
          </p>
        </td>
        <td width="174" valign="top" style="width: 130.7pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <o p="#DEFAULT">
            &#160;</o>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoNormal">
      <o p="#DEFAULT" style="line-height: 107%">
      &#160;</o>
    </p>
  </body>
</html>
</richcontent>
<node CREATED="1753765925647" ID="ID_431045120" MODIFIED="1753765957975" TEXT="Google Ads">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: .75in; text-indent: -.25in">
      <b><font size="10.0pt">1.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font></b><font size="10.0pt">Following information are required in IPC to integration Google Ads <b><o p="#DEFAULT" style="line-height: 107%"></o></b></font>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Budget Order Creation<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">App Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">1<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraph" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Developer token<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoNormal" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 1.0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraph" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">2<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <b><font size="10.0pt">Mcc<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoNormal" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 1.0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font size="10.0pt">3<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Email Address<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">4<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Client Secret <o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">5<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Client ID<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">6<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Access Token<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">7<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Refresh Token<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">8<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">9<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">11<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">12<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraph" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt"><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <b><font size="10.0pt" face="Aptos,sans-serif">Delivery<br style="line-height: 107%" /><br style="line-height: 107%" /></font></b>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753765984989" ID="ID_1289778887" MODIFIED="1753766127304" TEXT="GCM">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">UI integration<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.25in">
      <b><font size="10.0pt"><br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <o p="#DEFAULT" style="line-height: 107%">
      </o>
      </font></b>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">App Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">1<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Access_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Refresh_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">11<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">File store path<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">13<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Profile id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">14<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in">
      <b><font size="10.0pt"><br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <o p="#DEFAULT" style="line-height: 107%">
      </o>
      </font></b>
    </p>
    <p class="MsoListParagraphCxSpLast" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Delivery Pull<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <b><font size="10.0pt" face="Aptos,sans-serif">Report ID<br style="line-height: 107%" /><br style="line-height: 107%" /></font></b>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753766006776" ID="ID_1562374662" MODIFIED="1753766143080" TEXT="DV360">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">UI Integration<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">App Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">1<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Access_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Refresh_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">11<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">File store path<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">13<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Profile id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">14<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt"><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <p class="MsoListParagraphCxSpLast" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">c.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Delivery<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <b><font size="10.0pt" face="Aptos,sans-serif">Report ID<br style="line-height: 107%" /><br style="line-height: 107%" /></font></b>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753766032975" ID="ID_464679008" MODIFIED="1753766212417" TEXT="The TradeDesk">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">UI Integration<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">App Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">1<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Access_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Refresh_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">11<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">File store path<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">13<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Profile id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">14<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in">
      <b><font size="10.0pt"><o p="#DEFAULT" style="line-height: 107%">
      &#160;</o></font></b>
    </p>
    <p class="MsoListParagraphCxSpLast" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Delivery <o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <b><font size="10.0pt" face="Aptos,sans-serif">Schedule ID<br style="line-height: 107%" /><br style="line-height: 107%" /></font></b>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753766055578" ID="ID_650289972" MODIFIED="1753766256731" TEXT="LinkedIn">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">UI Integration<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">App Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">1<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Access_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Refresh_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">11<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">File store path<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">13<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Profile id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">14<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in">
      <b><font size="10.0pt"><br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <o p="#DEFAULT" style="line-height: 107%">
      </o>
      </font></b>
    </p>
    <p class="MsoListParagraphCxSpLast" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Delivery<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <b><font size="10.0pt" face="Aptos,sans-serif">Report ID<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /></font></b>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753766069280" ID="ID_1089714775" MODIFIED="1753766281192" TEXT="Twitter">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">UI Integration<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">App Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">1<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Access_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Refresh_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">11<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">File store path<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">13<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Profile id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">14<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in">
      <b><font size="10.0pt"><br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <o p="#DEFAULT" style="line-height: 107%">
      </o>
      </font></b>
    </p>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Delivery<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <p class="MsoListParagraphCxSpLast" style="margin-left: 1.75in; text-indent: -1.75in">
      <b><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">i.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Report ID<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753766088908" ID="ID_1820636436" MODIFIED="1753766291844" TEXT="FaceBook / Meta">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">UI Integration<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">App Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">1<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Access_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Refresh_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">11<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">File store path<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">13<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Profile id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">14<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in">
      <b><font size="10.0pt"><o p="#DEFAULT" style="line-height: 107%">
      &#160;</o></font></b>
    </p>
    <p class="MsoListParagraphCxSpLast" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Delivery<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <b><font size="10.0pt" face="Aptos,sans-serif">Report ID<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /></font></b>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753766167465" ID="ID_460903796" MODIFIED="1753766198670" TEXT="Microsoft Advertising">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <a name="_Hlk160066366"><b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">UI Integration<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b></a>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td>
          
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Dev Token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">2<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Master Account<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">3<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Refresh_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Access token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">12<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Store path<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td>
          
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">13<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td>
          
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in">
      <b><font size="10.0pt"><o p="#DEFAULT" style="line-height: 107%">
      &#160;</o></font></b>
    </p>
    <p class="MsoListParagraphCxSpLast" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Delivery<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <b><font size="10.0pt" face="Aptos,sans-serif">Report ID<br style="line-height: 107%" /><br style="line-height: 107%" /></font></b>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1753766235184" ID="ID_268453022" MODIFIED="1753766244413" TEXT="Yaoo">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">a.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">UI Integration<br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><br style="line-height: 107%" /><o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.25in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Entity<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">Description<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt">API_access_property_id<o p="#DEFAULT"></o></font></b>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">App Name<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">1<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Access_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">10<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Refresh_token<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">11<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">File store path<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">13<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
      <tr>
        <td width="208" valign="top" style="width: 155.8pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpFirst" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">Profile id<o p="#DEFAULT"></o></font>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font size="10.0pt"><o p="#DEFAULT">
            &#160;</o></font></b>
          </p>
        </td>
        <td width="208" valign="top" style="width: 155.85pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <font size="10.0pt">14<o p="#DEFAULT"></o></font>
          </p>
        </td>
      </tr>
    </table>
    <p class="MsoListParagraphCxSpFirst" style="margin-left: 1.25in">
      <b><font size="10.0pt"><br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <br style="line-height: 107%" />
      <o p="#DEFAULT" style="line-height: 107%">
      </o>
      </font></b>
    </p>
    <p class="MsoListParagraphCxSpLast" style="margin-left: 1.25in; text-indent: -.25in">
      <b><font size="10.0pt">b.</font><font size="7.0pt" face="Times New Roman">&#160;&#160;&#160;&#160;&#160; </font><font size="10.0pt">Delivery<o p="#DEFAULT" style="line-height: 107%"></o></font></b>
    </p>
    <b><font size="10.0pt" face="Aptos,sans-serif">Report ID<br style="line-height: 107%" /><br style="line-height: 107%" /></font></b>
  </body>
</html>
</richcontent>
</node>
</node>
<node CREATED="1753766027606" ID="ID_710483503" MODIFIED="1753768244998" TEXT="Generate Token for Nexelus / APWorks"/>
</node>
</node>
<node CREATED="1753766811198" ID="ID_1004549301" MODIFIED="1753766915683" TEXT="pdim_ad_tool">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p class="MsoListParagraphCxSpMiddle" style="margin-left: 1.0in; text-indent: -.25in">
      <b><font face="Times New Roman" size="3">&#160;</font><font size="3">AdTool IDs<o p="#DEFAULT" size="3" style="line-height: 107%"></o></font></b>
    </p>
    <p class="MsoListParagraphCxSpMiddle">
      <font size="3">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;(<u>pdim_ad_tool</u>)<br size="3" style="line-height: 107%" /><br size="3" style="line-height: 107%" /><o p="#DEFAULT" size="3" style="line-height: 107%"></o></font>
    </p>
    <table class="MsoTableGrid" border="1" cellspacing="0" cellpadding="0" style="margin-left: 1.0in; border-top-style: none; border-top-width: medium; border-right-style: none; border-right-width: medium; border-bottom-style: none; border-bottom-width: medium; border-left-style: none; border-left-width: medium">
      <tr>
        <td width="264" valign="bottom" style="width: 197.75pt; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpMiddle" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font color="black" face="Aptos Narrow,sans-serif" size="3">ad_tool_id</font></b><font size="3"><o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
        <td width="264" valign="bottom" style="width: 197.75pt; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt">
          <p class="MsoListParagraphCxSpLast" style="margin-top: 0in; margin-right: 0in; margin-bottom: 0in; margin-left: 0in; line-height: normal">
            <b><font color="black" face="Aptos Narrow,sans-serif" size="3">AdTool name</font></b><font size="3"><o p="#DEFAULT" size="3"></o>&#160;</font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">1<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">AdWords<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">2<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">AdCenter<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">6<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">GCM<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">13<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Sizmek<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">14<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">TradeDesk<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">15<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Facebook Ad<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">16<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">MS Ads<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">17<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Yahoo Gemini<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">19<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Google Ads<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">21<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Display &amp; Video 360<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">24<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">Twitter<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
      <tr style="height: 14.5pt">
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">25<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
        <td width="264" nowrap="nowrap" valign="top" style="width: 197.75pt; border-top-style: none; border-top-width: medium; border-left-style: none; border-left-width: medium; padding-top: 0in; padding-right: 5.4pt; padding-bottom: 0in; padding-left: 5.4pt; height: 14.5pt">
          <p class="MsoNormal" style="margin-bottom: 0in; line-height: normal">
            <font color="black" face="Aptos Narrow,sans-serif" size="3">LinkedIn<o p="#DEFAULT" size="3"></o></font>
          </p>
        </td>
      </tr>
    </table>
  </body>
</html>
</richcontent>
</node>
</node>
</node>
</map>
