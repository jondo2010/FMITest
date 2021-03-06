within FMITest.LinearSystems;
package TwoInertias
  "Test of two connected 1-dim. rotational inertias leading to a linear system of equations"
  extends Modelica.Icons.ExamplesPackage;
  model Reference "Reference solution in pure Modelica"
    extends Modelica.Icons.Example;
    Modelica.Mechanics.Rotational.Components.Inertia inertia1(
      J=1.1,
      phi(start=0, fixed=true),
      w(start=0, fixed=true))
      annotation (Placement(transformation(extent={{0,20},{20,40}})));
    Modelica.Mechanics.Rotational.Components.Inertia inertia2(
      J=2.2,
      phi(start=0, fixed=false),
      w(start=0, fixed=false))
      annotation (Placement(transformation(extent={{40,20},{60,40}})));
    Modelica.Mechanics.Rotational.Sources.Torque torque
      annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
    Modelica.Blocks.Sources.Sine sine(freqHz=2, amplitude=10)
      annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  equation
    connect(inertia1.flange_b, inertia2.flange_a) annotation (Line(
        points={{20,30},{40,30}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(torque.flange, inertia1.flange_a) annotation (Line(
        points={{-20,30},{0,30}},
        color={0,0,0},
        smooth=Smooth.None));
    connect(sine.y, torque.tau) annotation (Line(
        points={{-59,30},{-42,30}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), experiment(StopTime=1.1));
  end Reference;

  model WithFMUsReference
    "Reference solution in pure Modelica using exactly the same structuring as in Model WithFMUs"
    extends Modelica.Icons.Example;

    FMUModels.DirectInertia directInertia(J=1.1)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Modelica.Blocks.Sources.Sine sine(freqHz=2, amplitude=10)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    FMUModels.InverseInertia inverseInertia(J=2.2)
      annotation (Placement(transformation(extent={{20,0},{40,20}})));
  equation
    connect(directInertia.phi, inverseInertia.phi) annotation (Line(
        points={{1,18},{18,18}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(directInertia.w, inverseInertia.w) annotation (Line(
        points={{1,13},{10,13},{10,13},{18,13}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(directInertia.a, inverseInertia.a) annotation (Line(
        points={{1,7},{10,7},{10,7},{18,7}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sine.y, directInertia.tauDrive) annotation (Line(
        points={{-39,10},{-22,10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(inverseInertia.tau, directInertia.tau) annotation (Line(
        points={{19,2},{2,2}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), experiment(StopTime=1.1));
  end WithFMUsReference;

  model WithFMUs "Solution with FMUs"
    extends Modelica.Icons.Example;

    FMUModels.DirectInertia directInertia(J=1.1)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Modelica.Blocks.Sources.Sine sine(freqHz=2, amplitude=10)
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    FMUModels.InverseInertia inverseInertia(J=2.2)
      annotation (Placement(transformation(extent={{20,0},{40,20}})));
  equation
    connect(directInertia.phi, inverseInertia.phi) annotation (Line(
        points={{1,18},{18,18}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(directInertia.w, inverseInertia.w) annotation (Line(
        points={{1,13},{10,13},{10,13},{18,13}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(directInertia.a, inverseInertia.a) annotation (Line(
        points={{1,7},{10,7},{10,7},{18,7}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(sine.y, directInertia.tauDrive) annotation (Line(
        points={{-39,10},{-22,10}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(inverseInertia.tau, directInertia.tau) annotation (Line(
        points={{19,2},{2,2}},
        color={0,0,127},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics), experiment(StopTime=1.1));
  end WithFMUs;

  package FMUModels "For all models in this package an FMU must be generated"
    extends Modelica.Icons.Package;

    model DirectInertia "Input/output block of a direct inertia model"
      extends Modelica.Blocks.Interfaces.BlockIcon;
      Modelica.Mechanics.Rotational.Components.Inertia inertia(
        phi(start=0, fixed=true),
        w(start=0, fixed=true),
        J=J) annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
      parameter Modelica.SIunits.Inertia J=1 "Moment of inertia";
      Modelica.Mechanics.Rotational.Sources.Torque torque
        annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
      Modelica.Blocks.Interfaces.RealInput tauDrive
        "Accelerating torque acting at flange (= -flange.tau)"
        annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
      Utilities.RotFlangeToPhi flangeToPhi
        annotation (Placement(transformation(extent={{4,-10},{24,10}})));
      Modelica.Blocks.Interfaces.RealOutput phi(unit="rad")
        "Inertia moves with angle phi due to torque tau"
        annotation (Placement(transformation(extent={{100,70},{120,90}})));
      Modelica.Blocks.Interfaces.RealOutput w(unit="rad/s")
        "Inertia moves with speed w due to torque tau"
        annotation (Placement(transformation(extent={{100,20},{120,40}})));
      Modelica.Blocks.Interfaces.RealOutput a(unit="rad/s2")
        "Inertia moves with angular acceleration a due to torque tau"
        annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
      Modelica.Blocks.Interfaces.RealInput tau(unit="N.m")
        "Torque to drive the inertia"
        annotation (Placement(transformation(extent={{140,-100},{100,-60}})));
    equation

      connect(torque.flange, inertia.flange_a) annotation (Line(
          points={{-30,0},{-20,0}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(torque.tau, tauDrive) annotation (Line(
          points={{-52,0},{-120,0}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(inertia.flange_b, flangeToPhi.flange) annotation (Line(
          points={{0,0},{12,0}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(flangeToPhi.phi, phi) annotation (Line(
          points={{17,8},{60,8},{60,80},{110,80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(flangeToPhi.w, w) annotation (Line(
          points={{17,3},{66,3},{66,30},{110,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(flangeToPhi.tau, tau) annotation (Line(
          points={{18,-8},{60,-8},{60,-80},{120,-80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(flangeToPhi.a, a) annotation (Line(
          points={{17,-3},{66,-3},{66,-30},{110,-30}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}}), graphics), Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics={Text(
                  extent={{-84,-58},{24,-90}},
                  lineColor={135,135,135},
                  fillColor={235,245,255},
                  fillPattern=FillPattern.Solid,
                  textString="to FMU"),Text(
                  extent={{8,96},{92,66}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  textString="phi",
                  horizontalAlignment=TextAlignment.Right),Text(
                  extent={{10,46},{94,16}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  horizontalAlignment=TextAlignment.Right,
                  textString="w"),Text(
                  extent={{6,-10},{90,-40}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  horizontalAlignment=TextAlignment.Right,
                  textString="a"),Text(
                  extent={{-150,-110},{150,-140}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  textString="J=%J"),Bitmap(extent={{-96,54},{64,-42}},
              fileName="modelica://FMITest/Resources/Images/DirectInertia.png"),
              Text(
                  extent={{10,-60},{94,-90}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  horizontalAlignment=TextAlignment.Right,
                  textString="tau")}));
    end DirectInertia;

    model InverseInertia "Input/output block of an inverse inertia model"
      extends Modelica.Blocks.Interfaces.BlockIcon;
      Modelica.Mechanics.Rotational.Components.Inertia inertia(
        J=J,
        phi(start=0, fixed=false),
        w(start=0, fixed=false))
        annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
      parameter Modelica.SIunits.Inertia J=1 "Moment of inertia";
      Utilities.RotFlangeToTau rotFlangeToTau
        annotation (Placement(transformation(extent={{-36,-10},{-16,10}})));
      Modelica.Blocks.Interfaces.RealInput phi(unit="rad")
        "Angle to drive the inertia"
        annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
      Modelica.Blocks.Interfaces.RealInput w(unit="rad/s")
        "Speed to drive the inertia"
        annotation (Placement(transformation(extent={{-140,10},{-100,50}})));
      Modelica.Blocks.Interfaces.RealInput a(unit="rad/s2")
        "Angular acceleration to drive the inertia"
        annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
      Modelica.Blocks.Interfaces.RealOutput tau(unit="N.m")
        "Torque needed to drive the flange according to phi, w, a"
        annotation (Placement(transformation(extent={{-100,-90},{-120,-70}})));
    equation

      connect(rotFlangeToTau.phi, phi) annotation (Line(
          points={{-30,8},{-84,8},{-84,80},{-120,80}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(rotFlangeToTau.w, w) annotation (Line(
          points={{-30,2.8},{-90,2.8},{-90,30},{-120,30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(rotFlangeToTau.a, a) annotation (Line(
          points={{-30,-3.2},{-80,-3.2},{-80,-30},{-120,-30}},
          color={0,0,127},
          smooth=Smooth.None));
      connect(rotFlangeToTau.flange, inertia.flange_a) annotation (Line(
          points={{-24,0},{-12,0}},
          color={0,0,0},
          smooth=Smooth.None));
      connect(rotFlangeToTau.tau, tau) annotation (Line(
          points={{-29,-8},{-70,-8},{-70,-80},{-110,-80}},
          color={0,0,127},
          smooth=Smooth.None));
      annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
                -100,-100},{100,100}}), graphics), Icon(coordinateSystem(
              preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
            graphics={Text(
                  extent={{0,-62},{96,-94}},
                  lineColor={135,135,135},
                  fillColor={235,245,255},
                  fillPattern=FillPattern.Solid,
                  textString="to FMU"),Text(
                  extent={{-94,96},{-10,66}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  horizontalAlignment=TextAlignment.Left,
                  textString="phi"),Text(
                  extent={{-94,46},{-10,16}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  horizontalAlignment=TextAlignment.Left,
                  textString="w"),Text(
                  extent={{-92,-14},{-8,-44}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  horizontalAlignment=TextAlignment.Left,
                  textString="a"),Text(
                  extent={{-150,-110},{150,-140}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  textString="J=%J"),Bitmap(extent={{-58,48},{98,-42}},
              fileName="modelica://FMITest/Resources/Images/InverseInertia.png"),
              Text(
                  extent={{-90,-64},{-6,-94}},
                  lineColor={0,0,0},
                  fillPattern=FillPattern.HorizontalCylinder,
                  fillColor={245,245,245},
                  horizontalAlignment=TextAlignment.Left,
                  textString="tau")}));
    end InverseInertia;
  end FMUModels;
  annotation (preferredView="Info");
end TwoInertias;
