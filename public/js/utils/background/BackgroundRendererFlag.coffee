define ['threejs'], ->

  ###--------------------------------------------------------------------------
     SHADER
    --------------------------------------------------------------------------###

  VERTEX_SHADER = """
  uniform float location;
  uniform float wind;
  void main(void)
  {
    vec4 a = vec4(position, 1.0);

    a.z = sin(wind*a.x)*sin(wind*a.x + location); //Fahne stauchen

    //a.z =sin(wind*a.x)*sin(wind*a.y)*sin(location+a.x)+sin(wind*a.x);
    gl_Position = projectionMatrix * viewMatrix * a;
  }

  """

  FRAGMENT_SHADER = """
    void main() {
      gl_FragColor = vec4(1.0, 0.0, 1.0, 1.0);
    }
  """

  VIEW_ANGLE = 20
  NEAR = 1
  FAR = 10000
  CAM_FACTOR = 4

  camera = null
  scene = null
  renderer = null

  heightCamera = null
  heightScene = null
  heightRenderTarget = null

  uniforms = null
  heightUniforms = null

  time = new Date().getSeconds()

  init = ->
    is_chrome = navigator.userAgent.toLowerCase().indexOf('chrome') > -1

    ###--------------------------------------------------------------------------
     init height map
    --------------------------------------------------------------------------###

    # heightScene = new THREE.Scene()
    # heightCamera = new THREE.Camera()
    # heightCamera.position.z = 1
    # heightUniforms =
    #   time:
    #     type: "f"
    #     value: time

    # material = new THREE.ShaderMaterial
    #   uniforms: heightUniforms
    #   vertexShader: HEIGHT_VERTEX_SHADER
    #   fragmentShader: HEIGHT_FRAGMENT_SHADER

    # heightScene.add new THREE.Mesh new THREE.PlaneGeometry(2, 2), material

    # heightRenderTarget = new THREE.WebGLRenderTarget 512, 512,
    #   minFilter: THREE.LinearFilter
    #   magFilter: THREE.NearestFilter
    #   format: THREE.RGBFormat


    ###--------------------------------------------------------------------------
     init main scene
    --------------------------------------------------------------------------###

    scene = new THREE.Scene()
    camera = new THREE.OrthographicCamera -width() / CAM_FACTOR, width() / CAM_FACTOR, height() / CAM_FACTOR, -height() / CAM_FACTOR, NEAR, FAR

    camera.position.y = 60
    camera.position.z = 200
    camera.lookAt new THREE.Vector3 0, 0, 0
    scene.add camera

    renderer = new THREE.WebGLRenderer
      antialias: false
    renderer.setSize width(), height()
    canvas = $(renderer.domElement).hide().fadeIn(6000)
    canvas.addClass "noPrint"
    canvas.attr "id", "backgroundCanvas"
    $("body").append canvas

    material = new THREE.MeshBasicMaterial {color: 0xaaaaaa, side: THREE.DoubleSide}

    uniforms =
      wind:
        type: "f"
        value: 0.8
      location:
        type: "f"
        value: 1
      
    shaderMaterial = new THREE.ShaderMaterial
      uniforms: uniforms
      vertexShader: VERTEX_SHADER
      fragmentShader: FRAGMENT_SHADER

    geometry = new THREE.PlaneGeometry 700, 300, 100, 100
    plane = new THREE.Mesh geometry, shaderMaterial
    plane.rotation.x = -Math.PI / 2
    scene.add plane

    window.addEventListener 'resize', onWindowResize, false
    animate()

  onWindowResize = ->
    renderer.setSize width(), height()
    camera.left = -width() / CAM_FACTOR
    camera.right = width() / CAM_FACTOR
    camera.top = height() / CAM_FACTOR
    camera.bottom = -height() / CAM_FACTOR
    camera.updateProjectionMatrix()

  animate = ->
    requestAnimationFrame animate
    render()

  width = ->
    $(window).width()

  height = ->
    window.innerHeight

  render = ->
    uniforms.location.value = time
    time += 0.002
    renderer.render scene, camera

  exports =
    init: init
