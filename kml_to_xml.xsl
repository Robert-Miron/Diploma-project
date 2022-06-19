<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	xmlns:gx="http://www.google.com/kml/ext/2.2"
	xmlns:kml="http://www.opengis.net/kml/2.2"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:aixm="http://www.aixm.aero/schema/5.1"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:gml="http://www.opengis.net/gml/3.2"
	xmlns:fn="http://www.w3.org/2005/xpath-functions" version="3.0"
	xmlns:math="http://exslt.org/math" extension-element-prefixes="math"
	xmlns:uuid="java.util.UUID"
	xmlns:asrn="D:\Work\AMDB\asrn_extension"
	xmlns="http://www.aixm.aero/schema/5.1/message" exclude-result-prefixes="xs" xsi:schemaLocation="http://www.aixm.aero/schema/5.1/message http://www.aixm.aero/schema/5.1/message/AIXM_BasicMessage.xsd http://www.aixm.aero/schema/5.1/event http://www.aixm.aero/schema/5.1/event/Event_Features.xsd D:\Work\AMDB\asrn_extension D:\Work\AMDB\asrn_extension\asrn_Feature.xsd" gml:id="M0000001">
	<!-- Description: Conversion of ASRN features created with KML: nodes and edges Elements extracted: - Nodes: idnetwrk, nodeType, location, uuid - Edges: idnetwrk, edgeType, extent, uuid, startNode, endNode, length(computed), PCN and wingspan -->
	<!-- The KML elements should be created in the following way: *For node and edge - name - field1: idnetwrk of node/edge - field2: 'node' for node, 'edge' for edge, - field3: edge/node type code *For node - description - field1: own uuid *For edge - description - field1: own uuid - field2: uuid of connected start node - field3: uuid of connected end node - field4: PCN value - field5: PCN type and subgrade - field6: wingspan -->
	<xsl:template match="text() | @*">
		<!-- do nothing : to avoid copying text by default in the output -->
	</xsl:template>
	<!-- select="tokenize(normalize-space(child::description), '\s+')[1]"/> -->
	<!-- <xsl:value-of select="concat('uuid.', uuid:randomUUID())"/> -->
	<xsl:template match="/">
		<AIXMBasicMessage
			xmlns="http://www.aixm.aero/schema/5.1/message">
			<gml:boundedBy xsi:nil="true"/>
			<xsl:apply-templates/>
		</AIXMBasicMessage>
	</xsl:template>
	<xsl:template match="kml:Placemark">
		<!-- ASRN NODE -->
		<xsl:if test="tokenize(normalize-space(lower-case(child::kml:name)), '\s+')[2] = 'node'">
			<hasMember>
				<asrn:ASRNNode>
					<xsl:attribute name="gml:id">
						<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
					</xsl:attribute>
					<gml:identifier>
						<xsl:attribute name="codeSpace">
							<xsl:value-of select="'urn:uuid:'"/>
						</xsl:attribute>
						<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
					</gml:identifier>
					<gml:boundedBy>
						<xsl:attribute name="xsi:nil">
							<xsl:value-of select="'true'"/>
						</xsl:attribute>
					</gml:boundedBy>
					<!-- general (timeSlice) -->
					<asrn:timeSlice>
						<asrn:ASRNNodeTimeSlice>
							<xsl:attribute name="gml:id">
								<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
							</xsl:attribute>
							<gml:validTime>
								<gml:TimePeriod>
									<xsl:attribute name="gml:id">
										<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
									</xsl:attribute>
									<gml:beginPosition>2022-04-16T12:58:45Z</gml:beginPosition>
									<!-- Introduce here start time -->
									<gml:endPosition>
										<xsl:attribute name="indeterminatePosition">
											<xsl:value-of select="'unknown'"/>
										</xsl:attribute>
									</gml:endPosition>
									<!-- Introduce here end time -->
								</gml:TimePeriod>
							</gml:validTime>
							<aixm:interpretation>BASELINE</aixm:interpretation>
							<aixm:sequenceNumber>1</aixm:sequenceNumber>
							<!-- attributes -->
							<!-- logical names from associated features (idnetwrk) -->
							<asrn:nameInNetwork>
								<xsl:value-of select="tokenize(normalize-space(upper-case(child::kml:name)), '\s+')[1]"/>
							</asrn:nameInNetwork>
							<!-- associated terminal building (termref) -->
							<asrn:terminalBuilding>
								<xsl:attribute name="xsi:nil">
									<xsl:value-of select="'true'"/>
								</xsl:attribute>
							</asrn:terminalBuilding>
							<!-- functional type of ASRN node [nodetype] -->
							<asrn:type>
								<xsl:variable name="nodetype">
									<xsl:value-of select="tokenize(normalize-space(upper-case(child::kml:name)), '\s+')[3]" />
								</xsl:variable>
								<!-- <xsl:value-of select="$nodetype"/> -->
								<xsl:choose>
									<xsl:when test="$nodetype = '0'">
										<!-- Node where two taxiways meet -->
										<xsl:value-of select="'TAXIWAY_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '1'">
										<!-- Node on taxiway holding position. -->
										<xsl:value-of select="'TAXIWAY_HOLDING_POSITION_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '2'">
										<!-- Node where a runway and taxiway meet. -->
										<xsl:value-of select="'RUNWAY_ENTRY_EXIT_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '3'">
										<!-- Node where a runway exit line and runway intersection meet. -->
										<xsl:value-of select="'RUNWAY_EXIT_LINE_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '4'">
										<!-- Node where two runways meet -->
										<xsl:value-of select="'RUNWAY_INTERSECTION_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '5'">
										<!-- Node joining a parking area to a taxiway. -->
										<xsl:value-of select="'PARKING_ENTRY_EXIT_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '6'">
										<!-- Node joining an apron area to a taxiway. -->
										<xsl:value-of select="'APRON_ENTRY_EXIT_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '7'">
										<!-- Node on a taxiway abeam to a parking or apron entry/exit node. -->
										<xsl:value-of select="'TAXIWAY_LINK_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '8'">
										<xsl:value-of select="'DEICING_NODE'"/>
									</xsl:when>
									<xsl:when test="$nodetype = '9'">
										<!-- Node where a stand is located. -->
										<xsl:value-of select="'STAND_NODE'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'OTHER'"/>
									</xsl:otherwise>
								</xsl:choose>
							</asrn:type>
							<asrn:associatedAirportHeliport>
								<xsl:attribute name="xlink:href">
									<xsl:value-of select="'urn:uuid:D1E1D8D6-75B7-4843-8A6F-FB3EAC2DAD1A'"/>
								</xsl:attribute>
							</asrn:associatedAirportHeliport>
							<!-- holding position category [CAT_I CAT_II_III NON_PRECSION] -->
							<!-- point location -->
							<asrn:position>
								<aixm:ElevatedPoint>
									<xsl:attribute name="gml:id">
										<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
									</xsl:attribute>
									<xsl:attribute name="srsName">
										<xsl:value-of select="'urn:ogc:def:crs:EPSG::4326'"/>
									</xsl:attribute>
									<gml:pos>
										<xsl:value-of select="substring-before(substring-after(descendant::kml:Point/kml:coordinates, ','), ',')"/>
										<xsl:text> </xsl:text>
										<xsl:value-of select="substring-before(descendant::kml:Point/kml:coordinates, ',')" />
									</gml:pos>
									<aixm:horizontalAccuracy>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:horizontalAccuracy>
									<aixm:elevation>
										<xsl:attribute name="uom">
											<xsl:value-of select="'M'"/>
										</xsl:attribute>
										<xsl:value-of select="530.3"/>
										<!-- <xsl:value-of select="substring-after(substring-after(descendant::kml:Point/kml:coordinates,','),',')" /> -->
									</aixm:elevation>
									<aixm:geoidUndulation>
										<xsl:attribute name="uom">
											<xsl:value-of select="'M'"/>
										</xsl:attribute>
										<xsl:value-of select="45.3"/>
									</aixm:geoidUndulation>
									<aixm:verticalDatum>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:verticalDatum>
									<aixm:verticalAccuracy>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:verticalAccuracy>
								</aixm:ElevatedPoint>
							</asrn:position>
						</asrn:ASRNNodeTimeSlice>
					</asrn:timeSlice>
				</asrn:ASRNNode>
			</hasMember>
		</xsl:if>
		<!-- CONTINUE HERE ****-->
		<!-- ASRN EDGE -->
		<xsl:if test="tokenize(normalize-space(lower-case(child::kml:name)), '\s+')[2] = 'edge'">
			<hasMember>
				<asrn:ASRNEdge>
					<xsl:attribute name="gml:id">
						<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
					</xsl:attribute>
					<gml:identifier>
						<xsl:attribute name="codeSpace">
							<xsl:value-of select="'urn:uuid:'"/>
						</xsl:attribute>
						<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
					</gml:identifier>
					<!-- general (timeSlice) -->
					<asrn:timeSlice>
						<asrn:ASRNEdgeTimeSlice>
							<xsl:attribute name="gml:id">
								<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
							</xsl:attribute>
							<gml:validTime>
								<gml:TimePeriod>
									<xsl:attribute name="gml:id">
										<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
									</xsl:attribute>
									<gml:beginPosition>2022-04-16T12:58:45Z</gml:beginPosition>
									<!-- Introduce here start time -->
									<gml:endPosition>
										<xsl:attribute name="indeterminatePosition">
											<xsl:value-of select="'unknown'"/>
										</xsl:attribute>
									</gml:endPosition>
									<!-- Introduce here end time -->
								</gml:TimePeriod>
							</gml:validTime>
							<aixm:interpretation>BASELINE</aixm:interpretation>
							<aixm:sequenceNumber>1</aixm:sequenceNumber>
							<!-- attributes -->
							<!-- idnetwrk -->
							<asrn:nameInNetwork>
								<xsl:value-of select="tokenize(normalize-space(upper-case(child::kml:name)), '\s+')[1]"/>
							</asrn:nameInNetwork>
							<!-- navigation direction [BOTH FORWARD BACKWARD] -->
							<asrn:directionality>BOTH</asrn:directionality>
							<!-- edgetype -->
							<asrn:type>
								<xsl:variable name="edgetype">
									<xsl:value-of select="tokenize(normalize-space(child::kml:name), '\s+')[3]" />
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$edgetype = '0'">
										<!-- Edge along taxiway(s). -->
										<xsl:value-of select="'TAXIWAY_EDGE'"/>
									</xsl:when>
									<xsl:when test="$edgetype = '1'">
										<!-- Edge along runway(s). -->
										<xsl:value-of select="'RUNWAY_EDGE'"/>
									</xsl:when>
									<xsl:when test="$edgetype = '2'">
										<!-- Edge connecting runway and taxiway. -->
										<xsl:value-of select="'RUNWAY_EXIT_EDGE'"/>
									</xsl:when>
									<xsl:when test="$edgetype = '3'">
										<!-- Edge connecting taxiway and parking entry/exit point. -->
										<xsl:value-of select="'PARKING_EDGE'"/>
									</xsl:when>
									<xsl:when test="$edgetype = '4'">
										<!-- Edge connecting deicing and taxiway/parking/apron. -->
										<xsl:value-of select="'DEICING_EDGE'"/>
									</xsl:when>
									<xsl:when test="$edgetype = '5'">
										<!-- Edge connecting stand and parking entry/exit. -->
										<xsl:value-of select="'STAND_EDGE'"/>
									</xsl:when>
									<xsl:when test="$edgetype = '6'">
										<!-- Edge along apron(s). -->
										<xsl:value-of select="'APRON_EDGE'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'OTHER'"/>
									</xsl:otherwise>
								</xsl:choose>
							</asrn:type>
							<!-- edgederv [DERIVED FULLY_ABSTRACTED PARTIALLY_ABSTRACTED] rule can be introduced -->
							<asrn:derivationMethod>
								<xsl:value-of select="'FULLY_ABSTRACTED'"/>
							</asrn:derivationMethod>
							<!-- computed length which will be translated as cost -->
							<asrn:length>
								<!-- calculations principle described in chapter 8.3 -->
								<xsl:attribute name="uom">
									<xsl:value-of select="'M'"/>
								</xsl:attribute>
								<xsl:value-of select="'NaN'"/>
							</asrn:length>
							<asrn:nodeOne>
								<xsl:attribute name="xlink:type">
									<xsl:value-of select="'simple'"/>
								</xsl:attribute>
								<xsl:attribute name="xlink:href">
									<xsl:value-of select="'true'"/>
								</xsl:attribute>
							</asrn:nodeOne>
							<asrn:nodeTwo>
								<xsl:attribute name="xlink:type">
									<xsl:value-of select="'simple'"/>
								</xsl:attribute>
								<xsl:attribute name="xlink:href">
									<xsl:value-of select="'true'"/>
								</xsl:attribute>
							</asrn:nodeTwo>
							<asrn:associatedAirportHeliport>
								<xsl:attribute name="xlink:type">
									<xsl:value-of select="'simple'"/>
								</xsl:attribute>
								<xsl:attribute name="xlink:href">
									<xsl:value-of select="'urn:uuid:D1E1D8D6-75B7-4843-8A6F-FB3EAC2DAD1A'"/>
								</xsl:attribute>
							</asrn:associatedAirportHeliport>
							<asrn:associatedTaxiwayElement>
								<xsl:attribute name="xlink:type">
									<xsl:value-of select="'simple'"/>
								</xsl:attribute>
								<xsl:attribute name="xlink:href">
									<xsl:value-of select="'true'"/>
								</xsl:attribute>
							</asrn:associatedTaxiwayElement>
							<!-- string coordinates -->
							<asrn:curveExtent>
								<aixm:ElevatedCurve>
									<xsl:attribute name="gml:id">
										<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
									</xsl:attribute>
									<xsl:attribute name="srsName">
										<xsl:value-of select="'urn:ogc:def:crs:EPSG::4326'"/>
									</xsl:attribute>
									<gml:segments>
										<gml:GeodesicString>
											<gml:posList>
												<xsl:call-template name="loop">
													<xsl:with-param name="var">
														<xsl:value-of select="count(tokenize(normalize-space(descendant::kml:LineString/kml:coordinates)))" />
													</xsl:with-param>
												</xsl:call-template>
											</gml:posList>
										</gml:GeodesicString>
									</gml:segments>
								</aixm:ElevatedCurve>
							</asrn:curveExtent>
							<!-- relationships -->
							<asrn:aircraftCategory>
								<aixm:AircraftCharacteristic>
									<xsl:attribute name="gml:id">
										<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
									</xsl:attribute>
									<aixm:wingSpan>
										<xsl:attribute name="uom">
											<xsl:value-of select="'M'"/>
										</xsl:attribute>
										<xsl:value-of select="'50'" />
									</aixm:wingSpan>
								</aixm:AircraftCharacteristic>
							</asrn:aircraftCategory>
							<asrn:surfaceProperties>
								<aixm:SurfaceCharacteristics>
									<xsl:attribute name="gml:id">
										<xsl:value-of select="concat('uuid.', uuid:randomUUID())"/>
									</xsl:attribute>
									<aixm:composition>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:composition>
									<aixm:preparation>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:preparation>
									<aixm:surfaceCondition>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:surfaceCondition>
									<aixm:classPCN>
										<!-- <xsl:value-of select="tokenize(normalize-space(child::kml:description), '\s+')[4]" /><xsl:text></xsl:text> -->
										<xsl:value-of select="'85'" />
									</aixm:classPCN>
									<aixm:pavementTypePCN>
										<xsl:value-of select="'RIGID'"/>
									</aixm:pavementTypePCN>
									<aixm:pavementSubgradePCN>
										<xsl:value-of select="'D'"/>
									</aixm:pavementSubgradePCN>
									<aixm:maxTyrePressurePCN>
										<xsl:value-of select="'W'"/>
									</aixm:maxTyrePressurePCN>
									<aixm:evaluationMethodPCN>
										<xsl:value-of select="'TECH'"/>
									</aixm:evaluationMethodPCN>
									<aixm:classLCN>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:classLCN>
									<aixm:weightSIWL>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:weightSIWL>
									<aixm:tyrePressureSIWL>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:tyrePressureSIWL>
									<aixm:weightAUW>
										<xsl:attribute name="xsi:nil">
											<xsl:value-of select="'true'"/>
										</xsl:attribute>
									</aixm:weightAUW>
								</aixm:SurfaceCharacteristics>
							</asrn:surfaceProperties>
						</asrn:ASRNEdgeTimeSlice>
					</asrn:timeSlice>
				</asrn:ASRNEdge>
			</hasMember>
		</xsl:if>
	</xsl:template>
	<!-- loop for kml to epsg4326 coordinates switch -->
	<xsl:template name="loop">
		<xsl:param name="var"/>
		<xsl:choose>
			<xsl:when test="$var &gt; 0">
				<!-- <xsl:value-of select="descendant::kml:LineString/kml:coordinates"/> -->
				<xsl:value-of select="substring-before(substring-after(tokenize(normalize-space(descendant::kml:LineString/kml:coordinates), '\s+')[number($var)], ','), ',')"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="substring-before(tokenize(normalize-space(descendant::kml:LineString/kml:coordinates), '\s+')[number($var)], ',')"/>
				<xsl:text> </xsl:text>
				<xsl:call-template name="loop">
					<xsl:with-param name="var">
						<xsl:number value="number($var) - 1"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>