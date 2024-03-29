{{/*
Create chart name and version as used by the chart label.
*/}}

{{- define "ospl-config.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ospl-config.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "ospl-config.xml" -}}
<OpenSplice>
    <Domain>
        <Name>ospl_sp_ddsi</Name>
        <Id>{{- .Values.domainId | default 0 -}}</Id>
        <Description>Federated deployment using shared-memory and standard DDSI networking.</Description>
        <Database>
           <Size>{{- .Values.shmemSize | default 104857600 | int -}}</Size>
        </Database>
        {{- if .Values.domainReportEnabled }}
        <Report verbosity="DEBUG/>
        {{- end }}
        <Service name="ddsi2">
            <Command>ddsi2</Command>
        </Service>
        <Service name="durability">
            <Command>durability</Command>
        </Service>
        <Service enabled="false" name="cmsoap">
            <Command>cmsoap</Command>
        </Service>
        <ResourceLimits>
           <MaxSamples>
             <WarnAt>{{- .Values.maxSamplesWarnAt | default 50000 | int -}}</WarnAt>
           </MaxSamples>
        </ResourceLimits>
        <Daemon>
          <shmMonitor>
             <Scheduling>
               <Class>{{- .Values.schedulingClass | default "Default" -}}</Class>
               <Priority>{{- .Values.schedulingPriority | default 0 | int -}}</Priority>
             </Scheduling>
             <StackSize>{{- .Values.monitorStackSize | default 6000000 | int -}}</StackSize>
          </shmMonitor>
          <Watchdog>
             <Scheduling>
               <Class>{{- .Values.schedulingClass | default "Default" -}}</Class>
               <Priority>{{- .Values.schedulingPriority | default 0 | int -}}</Priority>
             </Scheduling>
             <StackSize>{{- .Values.monitorStackSize | default 6000000 | int -}}</StackSize>
          </Watchdog>
          <KernelManager>
             <Scheduling>
               <Class>{{- .Values.schedulingClass | default "Default" -}}</Class>
               <Priority>{{- .Values.schedulingPriority | default 0 | int -}}</Priority>
             </Scheduling>
             <StackSize>{{- .Values.monitorStackSize | default 6000000 | int -}}</StackSize>
          </KernelManager>
          <GarbageCollector>
             <Scheduling>
               <Class>{{- .Values.schedulingClass | default "Default" -}}</Class>
               <Priority>{{- .Values.schedulingPriority | default 0 | int -}}</Priority>
             </Scheduling>
             <StackSize>{{- .Values.monitorStackSize | default 6000000 | int -}}</StackSize>
          </GarbageCollector>
          <ResendManager>
             <Scheduling>
               <Class>{{- .Values.schedulingClass | default "Default" -}}</Class>
               <Priority>{{- .Values.schedulingPriority | default 0 | int -}}</Priority>
             </Scheduling>
             <StackSize>{{- .Values.monitorStackSize | default 6000000 | int -}}</StackSize>
          </ResendManager>
          <Heartbeat>
             <Scheduling>
               <Class>{{- .Values.schedulingClass | default "Default" -}}</Class>
               <Priority>{{- .Values.schedulingPriority | default 0 | int -}}</Priority>
             </Scheduling>
             <StackSize>{{- .Values.monitorStackSize | default 6000000 | int -}}</StackSize>
          </Heartbeat>
        </Daemon>
        <Listeners>
          <StackSize>{{- .Values.monitorStackSize | default 6000000 | int -}}</StackSize>
        </Listeners>
    </Domain>
    <DDSI2Service name="ddsi2">
        <General>
            <NetworkInterfaceAddress>{{- .Values.networkInterface | default "AUTO" -}}</NetworkInterfaceAddress>
            <AllowMulticast>true</AllowMulticast>
            <EnableMulticastLoopback>true</EnableMulticastLoopback>
            <CoexistWithNativeNetworking>false</CoexistWithNativeNetworking>
        </General>
        <Compatibility>
            <!-- see the release notes and/or the OpenSplice configurator on DDSI interoperability -->
            <StandardsConformance>lax</StandardsConformance>
            <!-- the following one is necessary only for TwinOaks CoreDX DDS compatibility -->
            <!-- <ExplicitlyPublishQosSetToDefault>true</ExplicitlyPublishQosSetToDefault> -->
        </Compatibility>
        <Discovery>
            <ParticipantIndex>none</ParticipantIndex>
            <DSGracePeriod>{{- .Values.dsGracePeriod | default "60s" -}}</DSGracePeriod>
        </Discovery>
        <Internal>
            <Watermarks>
               <WhcHigh>{{- .Values.waterMarksWhcHigh | default "8MB" -}}</WhcHigh>
               <WhcHighInit>{{- .Values.waterMarksWhcHighInit | default "8MB" -}}</WhcHighInit>
               <WhcAdaptive>{{- .Values.waterMarksWhcAdaptive | default "true" -}}</WhcAdaptive>
            </Watermarks>
            <DeliveryQueueMaxSamples>{{- .Values.deliveryQueueMaxSamples | default 2500 | int -}}</DeliveryQueueMaxSamples>
            <SquashParticipants>{{- .Values.squashParticipants | default "false" -}}</SquashParticipants>
            <ResponsivenessTimeout>${LSST_DDS_RESPONSIVENESS_TIMEOUT:-inf}</ResponsivenessTimeout>
        </Internal>
        {{- if .Values.ddsi2TracingEnabled }}
        <Tracing>
            <Verbosity>{{- .Values.ddsi2TracingVerbosity -}}</Verbosity>
            <OutputFile>{{- .Values.ddsi2TracingLogfile -}}</OutputFile>
        </Tracing>
        {{- end }}
    </DDSI2Service>
    <DurabilityService name="durability">
        {{- if .Values.durabilityServiceTracingEnabled }}
        <Tracing>
            <Verbosity>{{- .Values.durabilityServiceTracingVerbosity -}}</Verbosity>
            <OutputFile>{{- .Values.durabilityServiceTracingLogfile -}}</OutputFile>
        </Tracing>
        {{- end }}
        <Network>
            <InitialDiscoveryPeriod>{{- .Values.durabilityServiceInitialDiscoveryPeriod | default 10.0 -}}</InitialDiscoveryPeriod>
            <Alignment>
                <TimeAlignment>false</TimeAlignment>
                <RequestCombinePeriod>
                    <Initial>{{- .Values.durabilityServiceAlignmentComboPeriodInitial | default 5.0 -}}</Initial>
                    <Operational>{{- .Values.durabilityServiceAlignmentComboPeriodOperational | default 0.1 -}}</Operational>
                </RequestCombinePeriod>
            </Alignment>
            <WaitForAttachment maxWaitCount="100">
                <ServiceName>ddsi2</ServiceName>
            </WaitForAttachment>
        </Network>
        <NameSpaces>
            <NameSpace name="defaultNamespace">
                <Partition>${LSST_DDS_PARTITION_PREFIX}*</Partition>
            </NameSpace>
            <Policy alignee={{- .Values.namespacePolicyAlignee | default "Initial" | quote }}
                    aligner="${LSST_DDS_ALIGNER:-false}"
                    durability="Durable"
                    masterPriority="${OSPL_MASTER_PRIORITY:-1}"
                    nameSpace="defaultNamespace">
                <Merge scope="*" type="${LSST_DDS_MERGE_POLICY:-Ignore}"/>
            </Policy>
        </NameSpaces>
    </DurabilityService>
    <TunerService name="cmsoap">
        <Server>
            <PortNr>50000</PortNr>
        </Server>
    </TunerService>
</OpenSplice>
{{- end -}}
