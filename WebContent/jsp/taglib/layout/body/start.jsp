<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.Set"%>
<%@ page import="biblivre.core.translations.Languages"%>
<%@ page import="biblivre.core.translations.TranslationsMap"%>
<%@ page import="biblivre.core.translations.LanguageDTO"%>
<%@ page import="biblivre.view.LayoutUtils"%>
<%@ page import="biblivre.core.auth.AuthorizationPoints"%>
<%@ page import="biblivre.core.translations.LanguageDTO"%>
<%@ page import="biblivre.core.translations.LanguageDTO"%>
<%@ page import="biblivre.core.translations.LanguageDTO"%>
<%@ page import="biblivre.core.configurations.Configurations"%>
<%@ page import="biblivre.core.utils.Constants"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:useBean id="schema" type="java.lang.String" scope="request" />
<jsp:useBean id="translationsMap" type="biblivre.core.translations.TranslationsMap" scope="request" />
<jsp:useBean id="isMultiPart" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isDisableMenu" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isBanner" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isSchemaSelection" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isEmployee" type="java.lang.Boolean" scope="request" />
<jsp:useBean id="isLogged" type="java.lang.Boolean" scope="request" />

<c:set var="multiPartAttributes">
	enctype="multipart/form-data" accept-charset="UTF-8"
</c:set>
<c:set var="notMultiPartAttribute">
	onsubmit="return false;"
</c:set>

<body>
	<form id="page_submit" name="page_submit" method="post" ${isMultiPart ? pageScope.multiPartAttributes : pageScope.notMultiPartAttribute}>
		<input type="hidden" name="controller" id="controller" value='${isMultiPart ? "json" : "jsp"}'>
		<input type="hidden" name="module" id="module" value="login">
		<input type="hidden" name="action" id="action" value='${isLogged ? "logout" : "login"}'>

		<div id="header">
			<div id="logo_biblivre">
				<a href="http://biblivre.org.br/" target="_blank">
					<img src="static/images/logo_biblivre.png" width="117" height="66" alt="Biblivre V">
				</a>
			</div>

			<div id="logo_support">
				<div>
					<img src="static/images/logo_pedro_i.png" width="88" height="66" alt="Organização Pedro I">
				</div>
				<div>
					<img src="static/images/logo_sabin.png" width="88" height="66" alt="SABIN">
				</div>
				<div>
					<a href="http://www.bn.br/" target="_blank">
						<img src="static/images/logo_biblioteca_nacional.png" width="88" height="66" alt="Biblioteca Nacional">
					</a>
				</div>
				<div>
					<a href="http://www.cultura.gov.br/" target="_blank">
						<img src="static/images/logo_lei_de_incentivo.png" width="88" height="66" alt='${translationsMap.getHtml("header.law")}'>
					</a>
				</div>
			</div>

			<div id="logo_sponsor">
				<a href="http://www.itaucultural.org.br/" target="_blank">
					<img src="static/images/logo_itau.png" width="77" height="66" alt="Itaú Cultural">
				</a>
				<div id="clock">00:00</div>
			</div>

			<div id="title">
				<div id="logo_biblivre_small">
					<a href="http://biblivre.org.br/" target="_blank">
						<img src="static/images/logo_biblivre_small.png" width="43" height="36" alt="Biblivre V">
					</a>
				</div>
				<h1><a href="?">${Configurations.getHtml(schema, "general.title")}</a></h1>
				<h2>${Configurations.getHtml(schema, "general.subtitle")}</h2>
			</div>
			<c:if test="${languages.size() > 1}">
				<div id="language_selection">
					<select class="combo combo_auto_size" name="i18n" onchange="Core.submitForm('menu', 'i18n', 'jsp');">
					<c:forEach items="${languages}" var="dto">
						<c:set var="selectedAttr">
							${translationsMap.getLanguage().equals(dto.getLanguage()) ? "selected" : ""}
						</c:set>
						<option value="${dto.getLanguage()}" ${selectedAttr}>${dto.toString()}</option>
					</c:forEach>
			</select>
			</div>
			</c:if>
			<div id="menu">
				<ul>
					<c:choose>
						<c:when test="${isDisableMenu}">
							<c:out value="${utils.menuHelp(atps)}" escapeXml="false" />
						</c:when>
						<c:when test="${isSchemaSelection}">
							<c:choose>
								<c:when  test="${isLogged}">
									<c:out value='${utils.menuLevel(atps, "multi_schema", "administration_password",
									"multi_schema_manage", "multi_schema_configurations", "multi_schema_translations",
									"multi_schema_backup")}' escapeXml="false" />
									<c:out value="${utils.menuHelp(atps)}" escapeXml="false" />
									<c:out value="${utils.menuLogout()}" escapeXml="false" />
								</c:when>
								<c:otherwise>
									<c:out value='${utils.menuHelp(atps)}' escapeXml="false" />
									<c:out value='${utils.menuLogin()}' escapeXml="false" />
								</c:otherwise>
							</c:choose>
						</c:when>
						<c:otherwise>
							<c:choose>
								<c:when  test="${isEmployee}">
									<c:out value='${utils.menuLevel(atps, "search", "search_bibliographic", "search_authorities",
										"search_vocabulary", "search_z3950")}' escapeXml="false" />
									<c:out value='${utils.menuLevel(atps, "circulation", "circulation_user", "circulation_lending",
										"circulation_reservation", "circulation_access", "circulation_user_cards")}' escapeXml="false" />
									<c:out value='${utils.menuLevel(atps, "cataloging", "cataloging_bibliographic",
										"cataloging_authorities", "cataloging_vocabulary", "cataloging_import",
										"cataloging_labels")}' escapeXml="false" />
									<c:out value='${utils.menuLevel(atps, "cataloging", "cataloging_bibliographic",
										"cataloging_authorities", "cataloging_vocabulary", "cataloging_import",
										"cataloging_labels")}' escapeXml="false" />
									<c:out value='${utils.menuLevel(atps, "acquisition", "acquisition_supplier", "acquisition_request",
										"acquisition_quotation", "acquisition_order")}' escapeXml="false" />
									<c:out value='${utils.menuLevel(atps, "administration", "administration_password",
										"administration_permissions", "administration_user_types",
										"administration_access_cards", "administration_z3950_servers", "administration_reports",
										"administration_maintenance", "administration_configurations",
										"administration_translations", "administration_brief_customization",
										"administration_form_customization")}' escapeXml="false" />
									<c:out value='${utils.menuHelp(atps)}' escapeXml="false" />
									<c:out value='${utils.menuLogout()}' escapeXml="false" />
								</c:when>
								<c:when  test="${isLogged}">
									<c:out value='${utils.menuLevel(atps, "search", "search_bibliographic", "search_authorities",
										"search_vocabulary", "search_z3950")}' escapeXml="false" />
									<c:out value='${utils.menuLevel(atps, "self_circulation", "circulation_user_reservation")}' />
									<c:out value='${utils.menuLevel(atps, "administration", "administration_password")}' escapeXml="false" />
									<c:out value='${utils.menuHelp(atps)}' escapeXml="false"  />
									<c:out value='${utils.menuLogout()}' escapeXml="false" />
								</c:when>
								<c:otherwise>
									<c:out value='${utils.menuLevel(atps, "search", "search_bibliographic", "search_authorities",
										"search_vocabulary", "search_z3950")}' escapeXml="false" />
									<c:out value='${utils.menuHelp(atps)}' escapeXml="false" />
									<c:out value='${utils.menuLogin()}' escapeXml="false" />
								</c:otherwise>
							</c:choose>
						</c:otherwise>
					</c:choose>
				</ul>

				<div id=slider_area>
					<div id=slider ></div>
				</div>
			</div>
		</div>

		<div id=notifications>
			<div id=messages>

		<c:if test="${isLogged && !isDisableMenu}">
			<c:set var="passwordWarning" value='${schema}.system_warning_password' />
			<c:set var="backupWarning" value='${schema}.system_warning_backup' />
			<c:set var="indexingWarning" value='${schema}.system_warning_reindex' />
			<c:set var="updateWarning" value='${schema}.system_warning_new_version' />

			<c:if test='${sessionScope[passwordWarning]}'>
				<div class="message sticky error system_warning_password">
					<div>
						<c:out value='${translationsMap.getHtml("warning.change_password")}' escapeXml="false" />
						<a href="?action=administration_password" class="fright">
							<c:out value='${translationsMap.getHtml("warning.fix_now")}' escapeXml="false" />
						</a>
					</div>
				</div>
			</c:if>
			<c:if test="${sessionScope[backupWarning]}">
				<div class="message sticky error system_warning_backup">
					<div>
						<c:out value='${translationsMap.getHtml("warning.create_backup")}' escapeXml="false" />
						<a href="?action=administration_maintenance" class="fright">
							<c:out value='${translationsMap.getHtml("warning.fix_now")}' escapeXml="false" />
						</a>
					</div>
				</div>
			</c:if>

			<c:if test="${sessionScope[indexingWarning]}">
				<div class="message sticky error system_warning_reindex">
					<div>
						<c:out value='${translationsMap.getHtml("warning.reindex_database")}' escapeXml="false" />
							<a href="?action=administration_maintenance" class="fright">
								<c:out value='${translationsMap.getHtml("warning.fix_now")}' escapeXml="false" />
							</a>
					</div>
				</div>
			</c:if>

			<c:if test="${StringUtils.isNotBlank(updateWarning)}">
				<div class="message sticky error system_warning_new_version">
					<div>
						<div class="fright">
							<a href="javascript:void(0)" onclick="Core.ignoreUpdate(this);" class="close" target="_blank">&times;</a>
							<br>
							<a href="<c:out value='<%= Constants.DOWNLOAD_URL %>' />" target="_blank">
								<c:out value='${translationsMap.getHtml("warning.download_site")}' escapeXml="false" />
							</a>
						</div>
						<c:out value='${message}' escapeXml="false" />
					</div>
				</div>
			</c:if>
		</c:if>
		</div>
		<div id="breadcrumb">
			<div id="page_help_icon">
				<a onclick="PageHelp.show();"
					title='${translationsMap.getHtml("common.help")}'>?</a>
			</div>
		</div>
	</div>

	<div id="content_outer">
	<c:if test="${isBanner}">
		<div class="banner"></div>
	</c:if>
	<div id="content">

	<div class="px"></div>
	<div id="content_inner">

	<noscript>
		<c:out value='${translationsMap.getHtml("text.main.noscript")}' escapeXml="false" />
		<ul>
			<li>
				<a href="?action=list_bibliographic">Bibliográfica</a>
			</li>
			<%-- TODO: SEO -->
			<%-- <li><a href=\"?action=list_authorities\">Autoridades</a></li> --%>
			<%-- <li><a href=\"?action=list_vocabulary\">Vocabulário</a></li> --%>
		</ul>
	</noscript>