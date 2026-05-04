<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:math="http://www.w3.org/2005/xpath-functions/math" exclude-result-prefixes="#all"
    version="3.0">
    <xsl:output method="xhtml" html-version="5" include-content-type="no" omit-xml-declaration="no"
        indent="yes" encoding="UTF-8"/>
    <!-- ================================================================== -->
    <!-- TEMPLATE: DOCUMENT NODE                                            -->
    <!-- Create HTML doc                                                    -->
    <!-- ================================================================== -->
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="descendant::item[@type eq 'title']"/>
                    <style>
                        tr , th {
                        text-align: left;
                        }
                        table,
                        tr,
                        th,
                        td {
                        border: 1px solid gray;
                        }
                        table {
                        border-collapse: collapse;
                        margin-bottom: 1em;
                        }
                        th,
                        td {
                        padding: 2px 3px;
                        }
                        .info-section {
                        margin-top: 2rem;
                        }
                    </style>
                </title>
            </head>
            <body>
                <xsl:apply-templates/>
            </body>
        </html>
    </xsl:template>
    <!-- ================================================================== -->
    <!-- TEMPLATE: INTERLINEAR-TEXT (aka page)                              -->
    <!-- ================================================================== -->
    <xsl:template match="interlinear-text">
<!--        Calculate page number and add as div ID-->
        <!-- <xsl:variable name="page-num" select="count(preceding-sibling::interlinear-text) + 1"/> -->
    <!--Print title-->
    <!-- for troubleshooting only - keep this outside the div so Beautiful Soup won't pick it up -->
    <xsl:apply-templates select="item[@type eq 'title']"/>
    
    <!-- create div container with identifying info about the notebook page -->
        <xsl:variable name="page-num" select="substring-after(item[@type eq 'title'], '.')"/>
        

<!-- Handle interlinear, elicitation, and blank pages/pages with no linguistic data separately-->
            <xsl:try>
                <!-- <xsl:variable name="page_type" select="item[@type eq 'comment' and @lang eq 'en'][1] => normalize-space() => lower-case()"/> -->
              <xsl:variable name="page_type" select="item[@type eq 'comment' and @lang eq 'en'][1] => normalize-space() => lower-case()"/>
              <!-- <xsl:message>
                page_type: <xsl:value-of select="$page_type"/>, page: <xsl:value-of select="item[@type eq 'title']"/>
              </xsl:message> -->
                <xsl:if test="($page_type = 'elicitation' or $page_type = 'interlinear')">
                  <div class="page" id="{$page-num}">
            <!-- create transcription -->
                      <div class="text">
                        <xsl:apply-templates select="paragraphs" mode="text"/>
                      </div>
            <!-- if morpheme info, create additional div with linguistic info -->
                      <xsl:if test=".//morphemes">
                        <div class="linguistic">
                          <xsl:apply-templates select="paragraphs" mode="linguistic"/>
                        </div>
                      </xsl:if>
                  </div>
                </xsl:if>
<!--  Handle errors and print warning with page # that failed-->
                <xsl:catch>
                    <xsl:message>Warning: XSLT transformation failed for <xsl:value-of select="item[@type eq 'title']"/></xsl:message>
                </xsl:catch>
            </xsl:try>
        
    </xsl:template>
    <!-- ================================================================== -->
    <!-- TEMPLATE: TITLE                                                    -->
    <!-- ================================================================== -->
    <xsl:template match="item[@type eq 'title']">
        <h1>
            <xsl:apply-templates/>
        </h1>
    </xsl:template>
    <!-- ================================================================== -->
    <!-- TEMPLATE: WORD                                                               -->
    <!-- ================================================================== -->
    <xsl:template match="phrases/word" mode="text">
<!-- Determine page type-->
        <xsl:variable name="page_type" select="ancestor::interlinear-text/item[@type eq 'comment'][1] => normalize-space() => lower-case()"/>
<!-- Handle elicitation pages with gls and txt info (e.g. true elicitation) -->      
        <xsl:if test="$page_type eq 'elicitation' and (item[@type eq 'gls' and @lang eq 'en'] => string-length() gt 0) and (words/word/item[@type eq 'txt'] => string-join() => normalize-space() => string-length() gt 0)">
                <xsl:variable name="words_joined" select="words/word/item[@type eq 'txt'] => string-join(' ')"/>
                <p class="elicitation"><xsl:value-of select="$words_joined"/> = <xsl:value-of select="item[@type eq 'gls']"/></p>
              </xsl:if>
<!-- If elicitation with no gloss OR any text with no morpheme info, assume this is a freeform note and print text separated by spaces, with some cleanup to punctuation -->
        <xsl:if test="(not(.//morphemes) or $page_type eq 'elicitation') and not((item[@type eq 'gls' and @lang eq 'en'] => string-length() gt 0) and (words/word/item[@type eq 'txt'] => string-join() => normalize-space() => string-length() gt 0))">
          <xsl:variable name="words_joined" select="words/word/item => string-join(' ')"/>
          <!-- clean up punctuation -->
          <xsl:variable name="space_period" select="replace($words_joined, ' \.', '.')"/>
          <xsl:variable name="space_comma" select="replace($space_period, ' ,', ',')"/>
          <xsl:variable name="open_parenthesis" select="replace($space_comma, '\( ', '(')"/>
          <xsl:variable name="close_parenthesis" select="replace($open_parenthesis, ' \)', ')')"/>
          <xsl:variable name="semicolon" select="replace($close_parenthesis, ' ;', ';')"/>
          <xsl:variable name="pound" select="replace($semicolon, '# ', '#')"/>
          <xsl:variable name="colon" select="replace($pound, ' :', ':')"/>
          <!--- <xsl:variable name="open_brace" select="replace($colon, '{ ', '{')"/>
          <xsl:variable name="close_brace" select="replace($open_brace, ' }', '}')"/>
          <xsl:variable name="open_bracket" select="replace($close_brace, '[ ', '[')"/>
          <xsl:variable name="close_bracket" select="replace($open_bracket, ' ]', ']')"/> -->
          <p class="note"><xsl:value-of select="$colon"/></p>
        </xsl:if>
<!-- If interlinear text, print Tunica and English text -->
    <!-- TODO: instead test for the conditions currently in the if statements? -->
    <xsl:if test="$page_type eq 'interlinear' and (words/word/item[@type eq 'txt' and @lang eq 'qaa-x-aaa']/text() or words/word/item[@type eq 'gls' and @lang eq 'en']//text())">
      <table class="interlinear">
        <xsl:if test="words/word/item[@type eq 'txt' and @lang eq 'qaa-x-aaa']/text()">
          <tr class="interlinear-tunica">
            <xsl:for-each select="words/word">
              <xsl:if test="item[@type eq 'txt' and @lang eq 'qaa-x-aaa'] or item[@type eq 'gls' and @lang eq 'en']">
                <td>
                  <xsl:value-of select="item[@type eq 'txt' and @lang eq 'qaa-x-aaa']"/>
                </td>
              </xsl:if>
            </xsl:for-each>
          </tr>
        </xsl:if>
        <xsl:if test="words/word/item[@type eq 'gls' and @lang eq 'en']/text()">
          <tr class="interlinear-english">
            <xsl:for-each select="words/word">
              <xsl:if test="item[@type eq 'txt' and @lang eq 'qaa-x-aaa'] or item[@type eq 'gls' and @lang eq 'en']">
              <td>
                <xsl:value-of select="item[@type eq 'gls' and @lang eq 'en']"/>
              </td>
              </xsl:if>
            </xsl:for-each>
          </tr>
        </xsl:if>
      </table>
    </xsl:if>
  </xsl:template>
      <!-- ================================================================== -->
      <!-- TEMPLATE: TABLE                                                               -->
      <!-- ================================================================== -->
      <!-- If morpheme info, create table-->
  <xsl:template match="phrases/word" mode="linguistic">
      <xsl:if test=".//morphemes">
        <table class="linguistic-info">
          <tr>
            <th>Word</th>
            <xsl:apply-templates select="words/word[morphemes]/item[@type eq 'txt']" mode="colspan"
              />
          </tr>
          <tr>
            <th>Morphemes</th>
            <xsl:apply-templates select="descendant::morph/item[@type eq 'txt']"/>
          </tr>
          <!-- Rows describing Morpheme use for-each to avoid bug where morpheme data appears in incorrect cell-->
          <tr>
            <th>Modern Tunica</th>
            <xsl:for-each select="words/word/morphemes/morph">
              <td>
                <xsl:if test="item[@type eq 'gls' and @lang eq 'tun']">
                  <xsl:variable name="search_term" select="item[@type eq 'gls']"/>
                  <a href="https://www.webonary.org/tunica?s={$search_term}&amp;search=Search&amp;key=tun&amp;pos=&amp;search_options_set=1&amp;match_whole_words=1" target="blank"><xsl:value-of select="$search_term"/></a>
                </xsl:if>
              </td>
            </xsl:for-each>
          </tr>
          <!-- <tr>
               <th>Lex. Entries</th>
               <xsl:apply-templates select="descendant::morph/item[@type eq 'cf']"/>
          </tr> -->
          <tr>
            <th>Morpheme Type</th>
            <xsl:for-each select="words/word/morphemes/morph">
              <td>
                <xsl:if test="./@type">
                  <xsl:value-of select="./@type"/>
                </xsl:if>
              </td>
            </xsl:for-each>
            <!--                    <xsl:apply-templates select="words/word/morphemes/morph"/>-->
          </tr>
          <tr>
            <th>Grammatical Info</th>
            <xsl:for-each select="words/word/morphemes/morph">
              <td>
                <xsl:if test="item[@type eq 'msa']">
                  <xsl:value-of select="item[@type eq 'msa']"/>
                </xsl:if>
              </td>
            </xsl:for-each>
            <!--                    <xsl:apply-templates select="descendant::morph/item[@type eq 'msa']"/>-->
          </tr>
          <!--                If interlinear, print word gloss-->
          <xsl:if test="words/word[morphemes]/item[@type eq 'gls']/text()">
            <tr>
              <th>Word Gloss</th>
              <xsl:apply-templates select="words/word[morphemes]/item[@type eq 'gls']" mode="colspan"
                />
            </tr>
          </xsl:if>
        </table>
      </xsl:if>
    </xsl:template>
  <!-- ================================================================== -->
  <!-- TEMPLATE: TD (no colspan)                 -->
  <!-- ================================================================== -->
  <xsl:template match="item" mode="#all">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  <!-- ================================================================== -->
  <!-- TEMPLATE: TD (colspan)             -->
  <!-- ================================================================== -->
  <xsl:template match="item" mode="colspan" priority="10">
    <td colspan="{following-sibling::morphemes/morph => count()}">
      <xsl:apply-templates/>
    </td>
  </xsl:template> 
</xsl:stylesheet>
