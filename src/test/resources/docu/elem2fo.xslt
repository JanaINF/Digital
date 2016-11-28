<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fo="http://www.w3.org/1999/XSL/Format">

	<xsl:template match="root">
		<fo:root font-family="SansSerif" font-size="11pt" xml:lang="{@lang}">
			<fo:layout-master-set>
				<fo:simple-page-master master-name="DIN-A4"
									   page-height="29.7cm" page-width="21cm"
									   margin-top="2cm"     margin-bottom="1cm"
									   margin-left="2.5cm"  margin-right="2.5cm">
					<fo:region-body
							margin-top="1.3cm" margin-bottom="1.8cm"
							margin-left="0cm"  margin-right="0cm"/>
					<fo:region-before region-name="header" extent="1.3cm"/>
					<fo:region-after  region-name="footer" extent="1.5cm"/>
					<fo:region-start  region-name="left"   extent="0cm"/>
					<fo:region-end    region-name="right"  extent="0cm"/>
				</fo:simple-page-master>
			</fo:layout-master-set>
			<fo:page-sequence master-reference="DIN-A4">
				<fo:static-content flow-name="header">
					<fo:block font-size="14pt" text-align="right" border-bottom-style="solid">
						<xsl:value-of select="@titel"/>
					</fo:block>
				</fo:static-content>
				<fo:static-content flow-name="footer">
                    <fo:block text-align-last="justify" border-top-style="solid">
    					<fo:inline text-align="left" font-size="8pt">
                            <fo:basic-link external-destination="https://github.com/hneemann/Digital" show-destination="new">
                                https://github.com/hneemann/Digital
                            </fo:basic-link>
		    			</fo:inline>
                        <fo:leader/>
                        <fo:inline text-align="right">
                            <fo:page-number/> / <fo:page-number-citation ref-id="LastPage"/>
                        </fo:inline>
                    </fo:block>
				</fo:static-content>
				<fo:flow flow-name="xsl-region-body">
                    <!-- large title -->
					<fo:block margin-top="10mm" font-size="80pt" font-weight="bold">
						<xsl:value-of select="@titel"/>
					</fo:block>
                    <!-- image on title page -->
                    <fo:block margin-top="20mm" text-align="center">
                        <fo:external-graphic content-width="scale-to-fit" width="100%" src="url('{@titleImage}')"/>
                    </fo:block>


                    <fo:table table-layout="fixed" margin-top="3cm" width="100%">
                        <fo:table-column column-number="1" column-width="2.5cm"/>
                        <fo:table-column column-number="2" column-width="12cm"/>
                        <fo:table-body>
                            <fo:table-row>
                                <fo:table-cell column-number="1">
                                    <fo:block text-align="left"><xsl:value-of select="@revt"/>:</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="left"><xsl:value-of select="@rev"/></fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                            <fo:table-row>
                                <fo:table-cell column-number="1">
                                    <fo:block text-align="left"><xsl:value-of select="@datet"/>:</fo:block>
                                </fo:table-cell>
                                <fo:table-cell column-number="2">
                                    <fo:block text-align="left"><xsl:value-of select="@date"/></fo:block>
                                </fo:table-cell>
                            </fo:table-row>
                        </fo:table-body>
                    </fo:table>

                    <!-- table of contents text -->
                    <fo:block page-break-before="always" margin-bottom="5mm" font-size="18pt" font-weight="bold">
						<xsl:value-of select="@toc"/>
					</fo:block>
                    <!-- table of contents -->
					<fo:block>
						A <fo:inline padding-left="1mm"><xsl:value-of select="@general"/></fo:inline>
					</fo:block>
					<xsl:apply-templates select="document(@static)/*" mode="toc"/>
					<fo:block margin-top="2mm">
						B <fo:inline padding-left="1mm"><xsl:value-of select="@components"/></fo:inline>
					</fo:block>
					<xsl:apply-templates select="lib" mode="toc"/>
					<fo:block page-break-before="always"/>
                    <!-- the content -->
					<fo:block margin-top="4mm" margin-bottom="4mm" font-size="16pt" font-weight="bold">
						A <fo:inline padding-left="2mm"><xsl:value-of select="@general"/></fo:inline>
					</fo:block>
					<xsl:apply-templates select="document(@static)/*" mode="full"/>
					<fo:block page-break-before="always" margin-bottom="4mm" font-size="16pt" font-weight="bold">
						B <fo:inline padding-left="2mm"><xsl:value-of select="@components"/></fo:inline>
					</fo:block>
					<xsl:apply-templates select="lib" mode="full"/>
					<fo:block id="LastPage"/>
				</fo:flow>
			</fo:page-sequence>
		</fo:root>
	</xsl:template>

	<!-- Creation of the table of content-->
	<xsl:template match="chapter" mode="toc">
		<fo:block text-align-last="justify">
            <fo:basic-link show-destination="replace" internal-destination="chap_{position()}">
                <xsl:value-of select="position() div 2"/>. <xsl:value-of select="@name" />
            </fo:basic-link>
			<xsl:text> </xsl:text>
			<fo:leader leader-pattern="dots" />
            <fo:page-number-citation ref-id="chap_{position()}"/>
		</fo:block>
	</xsl:template>

	<xsl:template match="lib" mode="toc">
		<fo:block>
		    <xsl:value-of select="position()"/>. <xsl:value-of select="@name"/>
		</fo:block>
        <xsl:apply-templates select="element" mode="toc">
			<xsl:with-param name="number" select="position()"/>
        </xsl:apply-templates>
  	</xsl:template>

	<xsl:template match="element" mode="toc">
		<xsl:param name="number" />
		<fo:block margin-left="3mm" text-align-last="justify">
            <fo:basic-link show-destination="replace" internal-destination="{$number}_{position()}">
                <xsl:value-of select="$number"/>.<xsl:value-of select="position()"/>. <xsl:value-of select="@name"/>
            </fo:basic-link>
			<xsl:text> </xsl:text>
			<fo:leader leader-pattern="dots" />
            <fo:page-number-citation ref-id="{$number}_{position()}"/>
		</fo:block>
  	</xsl:template>

    <!-- Creation of the text -->
	<xsl:template match="chapter" mode="full">
        <fo:block page-break-after="avoid" margin-top="4mm" margin-bottom="4mm" font-size="14pt" font-weight="bold" id="chap_{position()}">
            <xsl:value-of select="position() div 2"/>. <xsl:value-of select="@name" />
        </fo:block>
        <xsl:apply-templates/>
	</xsl:template>

    <xsl:template match="par">
        <fo:block text-align="justify" hyphenate="true" >
			<xsl:apply-templates/>
        </fo:block>
    </xsl:template>

	<xsl:template match="e">
		<fo:inline font-style="italic" >
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>

	<xsl:template match="arrow">
		<fo:inline padding-left="2pt" font-family="ZapfDingbats">&#x2192;</fo:inline>
	</xsl:template>



    <xsl:template match="faq">
		<fo:block keep-together.within-page="always">
			<fo:block font-weight="bold" margin-top="3mm" margin-bottom="1mm">
				<xsl:apply-templates select="question"/>
			</fo:block>
			<fo:block margin-left="4mm">
				<xsl:apply-templates select="answer"/>
			</fo:block>
		</fo:block>
	</xsl:template>

	<xsl:template match="lib" mode="full">
		<fo:block page-break-after="avoid" margin-top="4mm" margin-bottom="4mm" font-size="16pt" font-weight="bold">
			<xsl:value-of select="position()"/>. <xsl:value-of select="@name"/>
		</fo:block>
		<xsl:apply-templates select="element" mode="full">
			<xsl:with-param name="number" select="position()"/>
		</xsl:apply-templates>
  	</xsl:template>

	<xsl:template match="element" mode="full">
		<xsl:param name="number" />

		<fo:block keep-together.within-page="always" page-break-after="avoid">
			<fo:block margin-top="6mm" >
                <fo:external-graphic src="url('{@img}')" id="{$number}_{position()}"/>
			</fo:block>
			<fo:block margin-top="4mm" margin-bottom="4mm" font-size="12pt" font-weight="bold">
				<xsl:value-of select="$number"/>.<xsl:value-of select="position()"/>. <xsl:value-of select="@name"/>
			</fo:block>
		</fo:block>

		<fo:block>
			<xsl:value-of select="descr"/>
		</fo:block>

        <xsl:apply-templates select="inputs"/>
        <xsl:apply-templates select="outputs"/>
        <xsl:apply-templates select="attributes"/>
  	</xsl:template>

	<xsl:template match="inputs">
		<fo:block margin-top="2mm" margin-bottom="2mm">
			<xsl:value-of select="@name"/>
		</fo:block>
		<xsl:apply-templates select="pin"/>
  	</xsl:template>

	<xsl:template match="outputs">
		<fo:block margin-top="2mm" margin-bottom="2mm">
			<xsl:value-of select="@name"/>
		</fo:block>
		<xsl:apply-templates select="pin"/>
  	</xsl:template>

	<xsl:template match="pin">
		<fo:block  margin-left="6mm">
			<xsl:value-of select="@name"/>
		</fo:block>
		<fo:block margin-left="12mm">
			<xsl:value-of select="."/>
		</fo:block>
  	</xsl:template>

	<xsl:template match="attributes">
		<fo:block margin-top="2mm" margin-bottom="2mm">
			<xsl:value-of select="@name"/>
		</fo:block>
		<xsl:apply-templates select="attr"/>
  	</xsl:template>

	<xsl:template match="attr">
		<fo:block  margin-left="6mm">
			<xsl:value-of select="@name"/>
		</fo:block>
		<fo:block margin-left="12mm">
			<xsl:value-of select="."/>
		</fo:block>
  	</xsl:template>

</xsl:stylesheet>